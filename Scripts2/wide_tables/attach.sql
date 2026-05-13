.print 'Running attach.sql'

-- expects to be run from root of `work-sql`
-- .read './Scripts2/wide_tables/attach.sql'

attach 'ducklake:../../../work/2026/asset_lake/asset_lake.ducklake' as asset_lake;