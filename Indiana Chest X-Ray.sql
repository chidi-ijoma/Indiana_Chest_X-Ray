SELECT TOP 10 *
FROM reports;

SELECT COUNT(*) AS total_records
FROM reports;

SELECT COUNT(*) AS normal_reports
FROM reports
WHERE LOWER(findings) LIKE '%normal%'
   OR LOWER(impression) LIKE '%normal%';

   SELECT COUNT(*) AS abnormal_reports
FROM reports
WHERE LOWER(findings) NOT LIKE '%normal%'
   AND LOWER(impression) NOT LIKE '%normal%';