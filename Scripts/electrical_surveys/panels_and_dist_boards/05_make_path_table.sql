.print 'Running 05_make_path_table.sql...'

-- The source data is likely to contain errors (cycles, breaks) so
-- we limit recursion depth with level
CREATE OR REPLACE TABLE electrical_surveys.sld_paths AS 
WITH RECURSIVE cte(site, item, path, level) USING KEY (site, item) AS (
    (SELECT
        t.site,
        t.child_item AS item,
        lpad(try_cast(t.item_num AS VARCHAR), 3, '0') || '..' || t.child_item  AS path,
        1 AS level,
    FROM electrical_surveys.vw_panel_parent_child  t
    WHERE t.this_item IS NULL)
UNION ALL
    (SELECT
        t.site,
        t.child_item AS item,
        cte.path || '::' || lpad(try_cast(t.item_num AS VARCHAR), 3, '0') || '..' || t.child_item AS path,
        1 + cte.level AS level,
    FROM electrical_surveys.vw_panel_parent_child t
    JOIN cte ON cte.site = t.site AND cte.item = t.this_item,
    WHERE cte.level < 18)
)
SELECT * RENAME(item AS db_or_panel_num, path AS sld_path) FROM cte;



