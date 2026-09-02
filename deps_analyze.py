#!/usr/bin/env python3
"""Derive test -> prerequisite-test dependencies from regress / isolation2
test sources.

Heuristic:
  * a test *provides* an object if it CREATEs it (non-temp) and does not DROP
    it in the same file;
  * a test *needs* an object if it references it (FROM/JOIN/INTO/UPDATE/DELETE/
    ALTER/TRUNCATE/ANALYZE/VACUUM/::type/nextval) without providing it itself;
  * if a needed object is provided by exactly one other test (and by few tests
    overall), emit an edge  needer -> provider.
Edges are kept only when the provider precedes the needer in the schedule.
"""
import os, re, sys, collections

ROOT = os.path.expanduser("~/gpdb_src/src/test")

SUITES = {
    "regress": dict(
        dir=os.path.join(ROOT, "regress"),
        sqldir="sql",
        schedules=["parallel_schedule", "greenplum_schedule"],
    ),
    "isolation2": dict(
        dir=os.path.join(ROOT, "isolation2"),
        sqldir="sql",
        schedules=["isolation2_schedule"],
    ),
}

# object names that are almost always local scratch relations
BLACKLIST = set("""
t t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 tt tab tbl tmp temp test tst foo bar baz qux
x y z a b c d e f g r s p q u v w foo1 bar1 t_1 xx yy zz src dst d1 d2 d3
a1 a2 b1 b2 c1 c2 r1 r2 s1 s2 p1 p2 parent child parent1 child1 mytable my_table
data results result input output rel rel1 rel2 tester dummy
tenk onek foo2 foo3 bar2 tbl1 tbl2 t0 tmp1 tmp2 v1 v2 v3 mv mv1 mv2
""".split())

# built-in types / pseudo-types (do not treat a "::foo" cast as a test dep)
BUILTIN_TYPES = set("""
int int2 int4 int8 integer bigint smallint serial bigserial
text varchar char bpchar character bool boolean bit varbit
numeric decimal float float4 float8 real money
date time timetz timestamp timestamptz interval abstime reltime tinterval
bytea name oid tid xid cid regproc regclass regtype regrole regnamespace
xml json jsonb jsonpath uuid inet cidr macaddr macaddr8
point line lseg box path polygon circle
tsvector tsquery txid_snapshot pg_lsn
anyarray anyelement anyrange record void trigger cstring unknown language_handler
""".split())

CREATE_RE = re.compile(
    r'\bcreate\s+(?:or\s+replace\s+)?'
    r'(?:global\s+|local\s+|unlogged\s+)?'
    r'(temp\s+|temporary\s+)?'
    r'(table|view|materialized\s+view|sequence|type|domain|'
    r'aggregate|operator\s+class|operator\s+family|index|'
    r'foreign\s+table)\s+'          # no schema/extension/collation/language:
    r'(?:if\s+not\s+exists\s+)?'    # those are environment, not test deps
    r'([a-z_][\w.$"]*)',
    re.I)

CTAS_RE = re.compile(r'\bcreate\s+(temp\s+|temporary\s+)?table\s+(?:if\s+not\s+exists\s+)?'
                     r'([a-z_][\w.$"]*)\s+as\b', re.I)
SELECT_INTO_RE = re.compile(r'\bselect\b.*?\binto\s+(temp\s+|temporary\s+)?'
                            r'([a-z_][\w.$"]*)', re.I | re.S)
FUNC_RE = re.compile(r'\bcreate\s+(?:or\s+replace\s+)?function\s+([a-z_][\w.$"]*)', re.I)
# capture the whole (possibly comma-separated) object list after DROP
DROP_RE = re.compile(r'\bdrop\s+(?:table|view|materialized\s+view|sequence|type|'
                     r'domain|aggregate|index|schema|extension|foreign\s+table|'
                     r'function|collation)\s+(?:if\s+exists\s+)?'
                     r'([a-z_][\w.$"]*(?:\s*,\s*[a-z_][\w.$"]*)*)', re.I)

# common words that are never a meaningful cross-test object dependency
STOPWORDS = set("""
comment comments table tables column columns index indexes view views data
value values result results name names type types function functions order
group level status count total main cache plan query queries role roles user
users public default primary foreign unique check active parent child source
target output input error errors config options version format header title
label entry item items list node nodes edge edges field fields page pages
block blocks state event events action actions rule rules policy language
extension schema collation trigger triggers domain sequence category document
account blog message messages person people student teacher record records
example sample master detail summary report reports history archive backup
plpythonu plpython2u plpython3u plperl plperlu pltcl pltclu plpgsql
dependent independent container content contents wrapper holder
""".split())

# generic scratch-relation name patterns (t1, tbl2, foo3, var1, xyz2, test4 ...)
SCRATCH_RE = re.compile(
    r'(t|tt|tbl|tab|tmp|temp|test|foo|bar|baz|qux|rel|obj|val|res|src|dst|'
    r'var|xyz|abc|col|row|rec|arr|idx|seq|vw|mv|x|y|z|a|b|c|d|e|f|g|p|q|r|s|u|v|w)'
    r'_?\d*$', re.I)

USE_RE = re.compile(
    r'\b(?:from|join|update|into|delete\s+from|truncate(?:\s+table)?|'
    r'analyze|vacuum(?:\s+full)?(?:\s+analyze)?|alter\s+table(?:\s+only)?|'
    r'lock(?:\s+table)?|reindex\s+(?:table|index)|cluster)\s+'
    r'([a-z_][\w.$"]*)',
    re.I)
CAST_RE = re.compile(r'::\s*([a-z_][\w.]*)', re.I)
NEXTVAL_RE = re.compile(r"nextval\('?([a-z_][\w.$\"]*)", re.I)

SQL_KW = set("""
select insert update delete values only lateral generate_series unnest
dual pg_class pg_namespace pg_attribute pg_type pg_proc pg_index pg_am
pg_catalog information_schema current_date current_time now
""".split())


def norm(name):
    name = name.strip().strip('"').lower()
    name = re.sub(r'[^\w.$]+$', '', name)
    if '.' in name:
        schema, _, obj = name.rpartition('.')
        if schema in ('pg_catalog', 'information_schema'):
            return None
        # keep an explicit non-system schema qualifier so e.g.
        # "singleseg.tenk1" does not collide with the real "tenk1"
        return name.replace('"', '') or None
    return name or None


def read_test(path):
    try:
        with open(path, encoding='utf-8', errors='replace') as fh:
            return fh.read()
    except FileNotFoundError:
        return None


def strip_sql_comments(txt):
    txt = re.sub(r'--[^\n]*', '', txt)
    txt = re.sub(r'/\*.*?\*/', '', txt, flags=re.S)
    return txt


def parse_schedule_order(sdir, schedules):
    order = {}
    i = 0
    for s in schedules:
        p = os.path.join(sdir, s)
        if not os.path.isfile(p):
            continue
        for line in open(p):
            line = line.strip()
            if not line.startswith('test:'):
                continue
            for tok in line[5:].split():
                if tok not in order:
                    order[tok] = i
                    i += 1
    return order


def analyze(suite, cfg):
    sdir = cfg["dir"]
    sqldir = os.path.join(sdir, cfg["sqldir"])
    order = parse_schedule_order(sdir, cfg["schedules"])

    # universe of tests: everything named in a schedule that has a .sql file
    tests = []
    for name in order:
        if os.path.isfile(os.path.join(sqldir, name + ".sql")):
            tests.append(name)
    tests_set = set(tests)

    provides = collections.defaultdict(set)   # obj -> {test}
    needs = collections.defaultdict(set)      # test -> {obj}
    test_text = {}                            # test -> comment-stripped sql
    test_created = {}                         # test -> {obj it makes/drops}

    for t in tests:
        raw = read_test(os.path.join(sqldir, t + ".sql"))
        if raw is None:
            continue
        txt = strip_sql_comments(raw)
        low = txt.lower()

        created, temp_created, dropped = set(), set(), set()
        for m in CREATE_RE.finditer(txt):
            is_temp, obj = m.group(1), norm(m.group(3))
            if not obj:
                continue
            (temp_created if is_temp else created).add(obj)
        for m in CTAS_RE.finditer(txt):
            obj = norm(m.group(2))
            if obj:
                (temp_created if m.group(1) else created).add(obj)
        for m in SELECT_INTO_RE.finditer(txt):
            obj = norm(m.group(2))
            if obj:
                (temp_created if m.group(1) else created).add(obj)
        for m in FUNC_RE.finditer(txt):
            obj = norm(m.group(1))
            if obj:
                created.add(obj)
        for m in DROP_RE.finditer(txt):
            for part in m.group(1).split(','):
                obj = norm(part)
                if obj:
                    dropped.add(obj)

        net = (created - dropped) - BLACKLIST
        for obj in net:
            provides[obj].add(t)
        test_text[t] = txt
        test_created[t] = created | temp_created | dropped

    # regress: tables are CREATEd in create_table.sql but populated in
    # copy.sql -- a test that reads their data really needs `copy`.
    forced_edges = collections.defaultdict(set)
    fixtures = set()          # known shared fixtures -> always trusted
    if suite == "regress":
        craw = strip_sql_comments(read_test(os.path.join(sqldir, "copy.sql")) or "")
        loaded = set()
        for m in re.finditer(r'\bcopy\s+([a-z_][\w.$"]*)\s+from\b', craw, re.I):
            obj = norm(m.group(1))
            if obj:
                loaded.add(obj)
        # created inside copy.sql itself -> not an external dependency
        made_in_copy = {norm(m.group(3)) for m in CREATE_RE.finditer(craw)}
        for obj in loaded - made_in_copy - BLACKLIST:
            provides[obj] = {"copy"}
            fixtures.add(obj)
        forced_edges["copy"].add("create_table")

    # keep only objects with a small, well-defined provider set and a name
    # distinctive enough that a bare mention in another test is meaningful.
    def distinctive(o):
        if o in fixtures:
            return True
        if (o in BLACKLIST or o in SQL_KW or o in BUILTIN_TYPES or o in STOPWORDS
                or SCRATCH_RE.fullmatch(o)):
            return False
        if '_' in o and len(o) >= 5:      # int8_tbl, tenk1_unique1, hash_i4_heap
            return True
        return len(o) >= 8               # equipment, brinopers_bloom, ...

    def trust(o, ps):
        if not distinctive(o):
            return False
        if o in fixtures:
            return True
        if len(ps) == 1:
            return True
        if len(ps) == 2 and (o.endswith('_tbl') or 'setup' in o or o.endswith('_heap')):
            return True
        return False
    good_provider = {o: ps for o, ps in provides.items() if trust(o, ps)}

    # a test "needs" a provided object if its text contains that identifier
    # as a bare token -- covers FROM/JOIN, ::type, and names inside string
    # literals such as brin_summarize_new_values('tenk1_unique1').
    ident = re.compile(r'[A-Za-z_][A-Za-z_0-9]*')
    prov_set = set(good_provider)
    for t in tests:
        toks = {m.group(0).lower() for m in ident.finditer(test_text.get(t, ""))}
        own = test_created.get(t, set())
        needs[t] = (toks & prov_set) - own

    edges = collections.defaultdict(set)  # test -> {prereq test}
    why = collections.defaultdict(set)    # (test, prereq) -> {obj}
    for t, objs in needs.items():
        to = order.get(t, 1 << 30)
        for o in objs:
            ps = good_provider.get(o)
            if not ps:
                continue
            for p in ps:
                if p == t:
                    continue
                if p not in tests_set:
                    continue
                if order.get(p, 1 << 30) < to:      # provider must come first
                    edges[t].add(p)
                    why[(t, p)].add(o)

    for t, ps in forced_edges.items():
        for p in ps:
            if order.get(p, 1 << 30) < order.get(t, 1 << 30):
                edges[t].add(p)
                why[(t, p)].add("(schedule fixture)")

    # drop transitively-implied edges (if T->A and A->B then drop T->B)
    _memo = {}

    def all_prereqs(t):
        if t in _memo:
            return _memo[t]
        _memo[t] = set()                      # cycle guard
        acc = set()
        for p in edges.get(t, ()):
            acc.add(p)
            acc |= all_prereqs(p)
        _memo[t] = acc
        return acc

    slim = {}
    for t, ps in edges.items():
        keep = set(ps)
        for p in ps:
            keep -= all_prereqs(p)
        if keep:
            slim[t] = sorted(keep, key=lambda x: order.get(x, 1 << 30))
    return order, slim, why


# Hand-curated edges the source scan cannot see (documented chains in the
# schedule headers, data-load ordering, etc). Merged into the derived map.
SEED = {
    "regress": {
        "create_type": ["create_function_1"],
        "create_table": ["create_function_1", "create_type"],
        "create_function_2": ["create_function_1", "create_type", "create_table"],
        "create_function_3": ["create_function_1"],
        "create_misc": ["create_table"],
        "create_operator": ["create_misc"],
        "create_procedure": ["create_misc"],
        "create_aggregate": ["create_misc"],
        "create_index": ["create_misc", "create_operator"],
        "create_index_spgist": ["create_index"],
        "create_view": ["create_misc", "create_operator"],
        "index_including": ["create_index"],
        "index_including_gist": ["create_index"],
        "gp_gin_index": ["create_index"],
    },
    # isolation2 tests are self-contained (they set up and tear down their own
    # state), so the source scan finds nothing. Only a few obvious pairs and
    # the gdd/* prefix rule (in the shell script) are worth encoding.
    "isolation2": {
        "uao_crash_compaction_row": ["uao_crash_compaction_column"],
        "idle_gang_cleaner": ["enable_autovacuum"],
        "enable_autovacuum": ["disable_autovacuum"],
        "gdd/end": ["gdd/prepare"],
    },
}


def merge(order, slim, seed):
    out = collections.defaultdict(set)
    for t, ps in slim.items():
        out[t].update(ps)
    for t, ps in seed.items():
        out[t].update(ps)

    def prereqs(t, seen):
        for p in out.get(t, ()):
            if p not in seen:
                seen.add(p)
                prereqs(p, seen)
        return seen

    res = {}
    for t, ps in out.items():
        keep = set(ps)
        for p in list(ps):
            keep -= prereqs(p, set())
        keep.discard(t)
        if keep:
            res[t] = sorted(keep, key=lambda x: order.get(x, 1 << 30))
    return res


def main():
    args = sys.argv[1:]
    verbose = '-v' in args
    as_bash = '--bash' in args
    want = [a for a in args if not a.startswith('-')] or list(SUITES)
    for suite in want:
        order, slim, why = analyze(suite, SUITES[suite])
        merged = merge(order, slim, SEED.get(suite, {}))
        keyf = lambda x: (order.get(x, 1 << 30), x)
        if as_bash:
            print(f"# {len(merged)} entries, generated from {suite} sources "
                  f"by deps_analyze.py")
            print("declare -A DEPS=(")
            for t in sorted(merged, key=keyf):
                print(f'  [{t}]="{" ".join(merged[t])}"')
            print(")")
            continue
        print(f"\n# ===== {suite}: {len(merged)} tests (derived + seed) =====")
        for t in sorted(merged, key=keyf):
            print(f'  [{t}]="{" ".join(merged[t])}"')
            if verbose:
                for p in merged[t]:
                    r = sorted(why[(t, p)]) or ["(seed)"]
                    print(f'      # {p}: {r}')


if __name__ == "__main__":
    main()
