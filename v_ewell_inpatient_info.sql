ALTER view dbo.v_ewell_inpatient_info
AS
SELECT CONVERT(VARCHAR, asy.id) AS patient_id,
	CONVERT(NUMERIC, ISNULL(asy.ry_no, 1)) AS series,
	asy.zyh AS admission_id,
	asy.xm AS name,
	RTRIM(LTRIM(asy.xb)) AS sex,
	asy.zkbmh AS dept_code,
	(SELECT tmp.bmm FROM zd_bm tmp WITH (NOLOCK) WHERE tmp.bmh = asy.zkbmh) AS dept_name,
	asy.bmh AS ward_code,
	zd_bm.bmm AS ward_name,
	asy.cwh AS bed_no,
	asy.csny AS birthday,
	CAST(asy.nl AS VARCHAR(20)) AS age,
	CASE WHEN ISNULL(asy.lxrdh, '') = '' THEN ISNULL(asy.dwdh, '') ELSE ISNULL(asy.lxrdh, '') END AS phone,
	CASE WHEN ISNULL(asy.jtdz, '') = '' THEN ISNULL(asy.gzdw, '') ELSE ISNULL(asy.jtdz, '') END AS address,
	asy.zy AS professional,
	asy.dwdh AS contact_info,
	CAST(NULL AS VARCHAR(20)) AS weight,
	CAST(NULL AS VARCHAR(20)) AS height,
	asy.ryrq AS admission_time,
	asy.rkrq AS admission_ward_time,
	asy.cyrq AS discharge_time,
	ISNULL( (SELECT  TOP 1 adqk.zddm FROM hisinterface_zy..ZY_BRZDQK adqk WITH (NOLOCK)
				WHERE adqk.zdlb = 1 AND adqk.zdlx = 0 AND adqk.syxh = asy.id), asy.ryzdh ) AS diagnosis_code,
	ISNULL( (SELECT  TOP 1 adqk.zdmc FROM hisinterface_zy..ZY_BRZDQK adqk WITH (NOLOCK)
				WHERE adqk.zdlb = 1 AND adqk.zdlx = 0 AND adqk.syxh = asy.id), asy.ryzd ) AS diagnosis,
	CASE asy.hljb WHEN 1 THEN '一级护理'
				WHEN 2 THEN '二级护理'
				WHEN 3 THEN '三级护理'
				WHEN 8 THEN '特级护理'
/*				WHEN 9 THEN '病重'
				WHEN 10 THEN '口告病重'*/
				ELSE CONVERT(VARCHAR, NULL) END AS nursing_class,
	CASE WHEN LTRIM(RTRIM(asy.bq)) IN ('病危', '病重') THEN LTRIM(RTRIM(asy.bq))
				WHEN asy.hljb = 9 THEN '病重'
				WHEN asy.hljb = 10 THEN '口告病重' ELSE CONVERT(VARCHAR, NULL) END AS patient_condition,
	asy.lbh AS charge_type,
	zd_gfjb2.lbm AS charge_type_name,
	CAST(NULL AS NUMERIC(9, 2)) AS total_cost,
	asy.yjj AS pre_payment,
	CAST(NULL AS NUMERIC(9, 2)) AS self_payment,
	CAST(NULL AS NUMERIC(9, 2)) AS balance,
	CASE asy.djbz WHEN 1 THEN '1' ELSE '0' END AS arrear_flag,
	CAST(NULL AS VARCHAR) AS diet,
	zd_ysk.ysm AS doctor_name,
	CASE WHEN asy.cyrq IS NULL THEN '住院' ELSE '预出院' END AS status,
	CASE asy.gmbz WHEN '1' THEN '青霉素过敏' WHEN '2' THEN '其他过敏' ELSE '' END AS allergy,
	CASE WHEN asy.glbz = '0' THEN NULL ELSE asy.glbz END AS glbzdj,
	CASE asy.glbz WHEN '1' THEN '接触传播隔离'
				WHEN '2' THEN '空气传播隔离'
				WHEN '3' THEN '飞沫传播隔离'
				WHEN '4' THEN '血源性隔离'
				WHEN '5' THEN '虫媒隔离'
				WHEN '6' THEN '保护性隔离'
				ELSE '非隔离' END AS glbzmc,
	asy.vte_jb AS vte_jb
FROM asy WITH (NOLOCK)
		LEFT OUTER JOIN zd_ysk WITH (NOLOCK) ON asy.ysh = zd_ysk.ysh
		LEFT OUTER JOIN zd_bm WITH (NOLOCK) ON asy.bmh = zd_bm.bmh
		INNER JOIN zd_gfjb2 WITH (NOLOCK) ON asy.lbh = zd_gfjb2.lbh

UNION ALL
SELECT CONVERT(VARCHAR, RTRIM(asy_yexx.br_id) + LTRIM(asy_yexx.ye_id)) AS patient_id,
	CONVERT(NUMERIC,ISNULL(asy.ry_no, 1)) AS series,
	asy.zyh AS admission_id,
	asy_yexx.xm AS name,
	RTRIM(LTRIM(asy_yexx.xb)) AS sex,
	asy.zkbmh AS dept_code,
	(SELECT tmp.bmm FROM zd_bm tmp WITH (NOLOCK) WHERE tmp.bmh = asy.zkbmh) AS dept_name,
	asy.bmh AS ward_code,
	zd_bm.bmm AS ward_name,
	LTRIM(RTRIM(asy.cwh)) + LTRIM(RTRIM(asy_yexx.cwh)) AS bed_no,
	asy_yexx.csrq AS birthday,
	CAST(NULL AS VARCHAR(20)) AS age,
	CASE WHEN ISNULL(asy.lxrdh, '') = '' THEN ISNULL(asy.dwdh, '') ELSE ISNULL(asy.lxrdh, '') END AS phone,
	CASE WHEN ISNULL(asy.jtdz, '') = '' THEN ISNULL(asy.gzdw, '') ELSE ISNULL(asy.jtdz, '') END AS address,
	asy.zy AS professional,
	asy.dwdh AS contact_info,
	cast(NULL AS VARCHAR(20)) AS weight,
	cast(NULL AS VARCHAR(20)) AS height,
	asy.ryrq AS admission_time,
	asy.rkrq AS admission_ward_time,
	asy.cyrq AS discharge_time,
	ISNULL( (SELECT TOP 1 adqk.zddm FROM hisinterface_zy..ZY_BRZDQK adqk WITH (NOLOCK)
				WHERE adqk.zdlb = 1 AND adqk.zdlx = 0 AND adqk.syxh = asy.id), asy.ryzdh ) AS diagnosis_code,
	ISNULL( (SELECT  TOP 1 adqk.zdmc FROM hisinterface_zy..ZY_BRZDQK adqk WITH (NOLOCK)
				WHERE adqk.zdlb = 1 AND adqk.zdlx = 0 AND adqk.syxh = asy.id), asy.ryzd ) AS diagnosis,
	CASE asy.hljb WHEN 1 THEN '一级护理'
				WHEN 2 THEN '二级护理'
				WHEN 3 THEN '三级护理'
				WHEN 8 THEN '特级护理'
/*				WHEN 9 THEN '病重'
				WHEN 10 THEN '口告病重'*/
				ELSE CONVERT(VARCHAR, NULL) END AS nursing_class,
	CASE WHEN LTRIM(RTRIM(asy.bq)) IN ('病危', '病重') THEN LTRIM(RTRIM(asy.bq))
				WHEN asy.hljb = 9 THEN '病重'
				WHEN asy.hljb = 10 THEN '口告病重' ELSE CONVERT(VARCHAR, NULL) END AS patient_condition,
	asy.lbh AS charge_type,
	zd_gfjb2.lbm AS charge_type_name,
	cast(NULL AS numeric(9, 2)) AS total_cost,
	asy.yjj AS pre_payment,
	cast(NULL AS numeric(9, 2)) AS self_payment,
	cast(NULL AS numeric(9, 2)) AS balance,
	CASE asy.djbz WHEN 1 THEN '1' ELSE '0' END AS arrear_flag,
	cast(NULL AS VARCHAR) AS diet,
	zd_ysk.ysm AS doctor_name,
	CASE WHEN asy.cyrq IS NULL THEN '住院' ELSE '预出院' END AS status,
	CASE asy.gmbz WHEN '1' THEN '青霉素过敏' WHEN '2' THEN '其他过敏' ELSE '' END AS allergy, '' AS glbzdj,
	'' AS glbzmc,
	'' AS vte_jb
FROM asy WITH (NOLOCK)
		LEFT OUTER JOIN zd_ysk WITH (NOLOCK) ON asy.ysh = zd_ysk.ysh
		LEFT OUTER JOIN zd_bm WITH (NOLOCK) ON asy.bmh = zd_bm.bmh
		INNER JOIN asy_yexx WITH (NOLOCK) ON asy.id = asy_yexx.br_id
		INNER JOIN zd_gfjb2 WITH (NOLOCK) ON asy.lbh = zd_gfjb2.lbh
