/*检查视图是否存在*/
SELECT * FROM sys.views WHERE name like 'v_ewell_%'

/*检查默认跟踪是否开启 value为1表示开启 会生成log*.trc跟踪日志文件*/
/*详细说明：http://www.cnblogs.com/gaizai/p/3358998.html；*/
SELECT * FROM sys.configurations WHERE configuration_id = 1568

/*内联表值函数，可替代视图*/
ALTER FUNCTION f_inline_zybr(@brid int,@zyh varchar(8),@cyrq1 datetime,@cyrq2 datetime)
RETURNS TABLE 
AS
RETURN 
(
	SELECT id,zyh,xm,ryrq,cyrq,0 as bz
	FROM asy
	WHERE
		(
			( @brid > 0 and asy.id = @brid ) OR
			( ISNULL(@brid,0) <= 0 and asy.zyh = @zyh ) OR
			( ISNULL(@brid,0)<=0 AND RTRIM(ISNULL(@zyh,'')) = '' AND @cyrq1 IS NOT NULL AND @cyrq2 IS NOT NULL AND asy.cyrq >= @cyrq1 AND asy.cyrq <= @cyrq2 ) OR
			( ISNULL(@brid,0)<=0 AND RTRIM(ISNULL(@zyh,'')) = '' AND (@cyrq1 IS NULL or @cyrq2 IS NULL) AND 1 = 2 )
		)

	UNION ALL
	SELECT ano,zyh,xm,ryrq,cyrq,1 as bz
	FROM asyc
	WHERE
		(
			( @brid > 0 and asyc.ano = @brid ) OR
			( ISNULL(@brid,0) <= 0 and asyc.zyh = @zyh ) OR
			( ISNULL(@brid,0)<=0 AND RTRIM(ISNULL(@zyh,'')) = '' AND @cyrq1 IS NOT NULL AND @cyrq2 IS NOT NULL AND asyc.cyrq >= @cyrq1 AND asyc.cyrq <= @cyrq2 ) OR
			( ISNULL(@brid,0)<=0 AND RTRIM(ISNULL(@zyh,'')) = '' AND (@cyrq1 IS NULL or @cyrq2 IS NULL) AND 1 = 2 )
		) AND
		asyc.cyrq IS NOT NULL AND asyc.lfbz IS NULL
)


/*从执行计划缓存中找出和表值函数做Join的查询*/
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
SELECT  st.text,
        qp.query_plan
FROM    (
    SELECT  TOP 50 *
    FROM    sys.dm_exec_query_stats
    ORDER BY total_worker_time DESC
) AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
WHERE qp.query_plan.exist('//p:RelOp[contains(@LogicalOp, "Join")]/*/p:RelOp[(@LogicalOp[.="Table-valued function"])]') = 1
