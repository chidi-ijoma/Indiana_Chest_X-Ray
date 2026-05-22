--View the Dataset--
SELECT TOP 10 *
FROM reports;

--Count all records--
SELECT COUNT(*) AS total_records
FROM reports;

--Count all normal records--
SELECT COUNT(*) AS normal_reports
FROM reports
WHERE LOWER(findings) LIKE '%normal%'
   OR LOWER(impression) LIKE '%normal%';

--Count all abnormal records--
SELECT COUNT(*) AS abnormal_reports
FROM reports
WHERE LOWER(findings) NOT LIKE '%normal%'
   AND LOWER(impression) NOT LIKE '%normal%';

--Count specific conditions--
--Pneumonia--
SELECT COUNT(*) AS pneumonia_cases
FROM reports
WHERE LOWER(findings) LIKE '%pneumonia%'
   OR LOWER(impression) LIKE '%pneumonia%';

--Effusion--
SELECT COUNT(*) AS effusion_cases
FROM reports
WHERE LOWER(findings) LIKE '%effusion%'
   OR LOWER(impression) LIKE '%effusion%';

--Mass--
SELECT COUNT(*) AS mass_cases
FROM reports
WHERE LOWER(findings) LIKE '%mass%'
   OR LOWER(impression) LIKE '%mass%';

--Fracture--
SELECT COUNT(*) AS fracture_cases
FROM reports
WHERE LOWER(findings) LIKE '%fracture%'
   OR LOWER(impression) LIKE '%fracture%';

--Comparing pneumonia cases in findings and impressions vs problems--
SELECT COUNT(*) AS pneumonia_cases
FROM reports
WHERE LOWER(findings) LIKE '%pneumonia%'
	OR LOWER(impression) LIKE '%pneumonia%';

SELECT COUNT(*) AS pneumonia_labels
FROM reports
WHERE LOWER(problems) LIKE '%pneumonia%';