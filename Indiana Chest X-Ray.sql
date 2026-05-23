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


--Correct for null values--
--Count of abnormal cases--
SELECT COUNT(*) AS abnormal_reports
FROM reports
WHERE LOWER(ISNULL(findings,'')) NOT LIKE '%normal%'
AND LOWER(ISNULL(impression,'')) NOT LIKE '%normal%';


--Count of effusion cases--
SELECT COUNT(*) AS true_effusion_cases
FROM reports
WHERE (
      LOWER(ISNULL(findings,'')) LIKE '%effusion%'
      OR LOWER(ISNULL(impression,'')) LIKE '%effusion%'
)
AND LOWER(ISNULL(findings,'')) NOT LIKE '%no pleural effusion%'
AND LOWER(ISNULL(impression,'')) NOT LIKE '%no pleural effusion%';

--Count of pneumonia cases--
SELECT COUNT(*) AS true_pneumonia_cases
FROM reports
WHERE (
    LOWER(ISNULL(findings,'')) LIKE '%pneumonia%'
    OR LOWER(ISNULL(impression,'')) LIKE '%pneumonia%'
)
AND LOWER(ISNULL(findings,'')) NOT LIKE '%no focal air space opacity to suggest a pneumonia%'
AND LOWER(ISNULL(impression,'')) NOT LIKE '%no pneumonia%';


--Create Diagnosis category--
SELECT
    uid,

    CASE
        WHEN LOWER(ISNULL(impression,'')) LIKE '%pneumonia%'
             AND LOWER(ISNULL(impression,'')) NOT LIKE '%no pneumonia%'
        THEN 'Pneumonia'

        WHEN LOWER(ISNULL(impression,'')) LIKE '%effusion%'
             AND LOWER(ISNULL(impression,'')) NOT LIKE '%no pleural effusion%'
        THEN 'Pleural Effusion'

        WHEN LOWER(ISNULL(impression,'')) LIKE '%fracture%'
        THEN 'Fracture'

        WHEN LOWER(ISNULL(impression,'')) LIKE '%mass%'
        THEN 'Mass'

        WHEN LOWER(ISNULL(problems,'')) LIKE '%normal%'
        THEN 'Normal'

        ELSE 'Other'
    END AS diagnosis_category

FROM reports;


--Count of each diagnosis category--
SELECT
    diagnosis_category,
    COUNT(*) AS total
FROM
(
    SELECT
        CASE
            WHEN LOWER(ISNULL(impression,'')) LIKE '%pneumonia%'
                 AND LOWER(ISNULL(impression,'')) NOT LIKE '%no pneumonia%'
            THEN 'Pneumonia'

            WHEN LOWER(ISNULL(impression,'')) LIKE '%effusion%'
                 AND LOWER(ISNULL(impression,'')) NOT LIKE '%no pleural effusion%'
            THEN 'Pleural Effusion'

            WHEN LOWER(ISNULL(impression,'')) LIKE '%fracture%'
            THEN 'Fracture'

            WHEN LOWER(ISNULL(impression,'')) LIKE '%mass%'
            THEN 'Mass'

            WHEN LOWER(ISNULL(problems,'')) LIKE '%normal%'
            THEN 'Normal'

            ELSE 'Other'
        END AS diagnosis_category
    FROM reports
) classified_reports

GROUP BY diagnosis_category
ORDER BY total DESC;