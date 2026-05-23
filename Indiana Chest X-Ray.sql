/* ==========================================================
   RADIOLOGY NLP PROJECT - CLEAN SQL PIPELINE (V1)
   Methodology:
   - Impression = primary diagnosis source
   - Findings = fallback only if impression missing
   - Problems = validation only
   - Multi-label classification
========================================================== */


/* ==========================================
1. View Dataset
========================================== */

SELECT TOP 10 *
FROM reports;



/* ==========================================
2. Dataset Size
========================================== */

SELECT COUNT(*) AS total_records
FROM reports;



/* ==========================================
3. Missing Value Audit
(Important for methodology section)
========================================== */

SELECT
    COUNT(*) AS total_records,

    SUM(CASE WHEN findings IS NULL THEN 1 ELSE 0 END)
        AS missing_findings,

    SUM(CASE WHEN impression IS NULL THEN 1 ELSE 0 END)
        AS missing_impression,

    SUM(CASE WHEN problems IS NULL THEN 1 ELSE 0 END)
        AS missing_problems

FROM reports;



/* ==========================================
4. Create Unified Clinical Text
Impression first.
If missing, use findings.
========================================== */

SELECT
    uid,

    COALESCE(impression, findings, '') AS clinical_text

FROM reports;



/* ==========================================
5. Count Normal Studies
========================================== */

SELECT COUNT(*) AS normal_reports
FROM reports
WHERE LOWER(COALESCE(impression, findings, ''))
LIKE '%normal%';



/* ==========================================
6. Count Abnormal Studies
========================================== */

SELECT COUNT(*) AS abnormal_reports
FROM reports
WHERE LOWER(COALESCE(impression, findings, ''))
NOT LIKE '%normal%';



/* ==========================================
7. Disease Counts
NEGATION-AWARE
========================================== */


-- Pneumonia
SELECT COUNT(*) AS pneumonia_cases
FROM reports
WHERE
LOWER(COALESCE(impression, findings, ''))
LIKE '%pneumonia%'
AND LOWER(COALESCE(impression, findings, ''))
NOT LIKE '%no%pneumonia%'
AND LOWER(COALESCE(impression, findings, ''))
NOT LIKE '%without%pneumonia%'
AND LOWER(COALESCE(impression, findings, ''))
NOT LIKE '%suggest a pneumonia%';



-- Pleural Effusion
SELECT COUNT(*) AS effusion_cases
FROM reports
WHERE
LOWER(COALESCE(impression, findings, ''))
LIKE '%effusion%'
AND LOWER(COALESCE(impression, findings, ''))
NOT LIKE '%no%effusion%'
AND LOWER(COALESCE(impression, findings, ''))
NOT LIKE '%without%effusion%'
AND LOWER(COALESCE(impression, findings, ''))
NOT LIKE '%effusion identified%';



-- Fracture
SELECT COUNT(*) AS fracture_cases
FROM reports
WHERE
LOWER(COALESCE(impression, findings, ''))
LIKE '%fracture%'
AND LOWER(COALESCE(impression, findings, ''))
NOT LIKE '%no%fracture%';



-- Mass
SELECT COUNT(*) AS mass_cases
FROM reports
WHERE
LOWER(COALESCE(impression, findings, ''))
LIKE '%mass%'
AND LOWER(COALESCE(impression, findings, ''))
NOT LIKE '%no%mass%';



/* ==========================================
8. Compare Pneumonia Detection
Model vs Label
========================================== */

SELECT COUNT(*) AS predicted_pneumonia
FROM reports
WHERE
LOWER(COALESCE(impression, findings, ''))
LIKE '%pneumonia%'
AND LOWER(COALESCE(impression, findings, ''))
NOT LIKE '%no%pneumonia%';


SELECT COUNT(*) AS pneumonia_labels
FROM reports
WHERE LOWER(COALESCE(problems,''))
LIKE '%pneumonia%';



/* ==========================================
9. Multi-label Clinical Classification
THIS BECOMES POWER BI TABLE
========================================== */

SELECT

    uid,

    COALESCE(impression, findings, '')
    AS clinical_text,

    CASE
        WHEN
        LOWER(COALESCE(impression, findings, ''))
        LIKE '%pneumonia%'
        AND LOWER(COALESCE(impression, findings, ''))
        NOT LIKE '%no%pneumonia%'
        THEN 1
        ELSE 0
    END AS pneumonia,


    CASE
        WHEN
        LOWER(COALESCE(impression, findings, ''))
        LIKE '%effusion%'
        AND LOWER(COALESCE(impression, findings, ''))
        NOT LIKE '%no%effusion%'
        THEN 1
        ELSE 0
    END AS pleural_effusion,


    CASE
        WHEN
        LOWER(COALESCE(impression, findings, ''))
        LIKE '%fracture%'
        AND LOWER(COALESCE(impression, findings, ''))
        NOT LIKE '%no%fracture%'
        THEN 1
        ELSE 0
    END AS fracture,


    CASE
        WHEN
        LOWER(COALESCE(impression, findings, ''))
        LIKE '%mass%'
        AND LOWER(COALESCE(impression, findings, ''))
        NOT LIKE '%no%mass%'
        THEN 1
        ELSE 0
    END AS mass,


    CASE
        WHEN LOWER(COALESCE(problems,''))
        LIKE '%normal%'
        THEN 1
        ELSE 0
    END AS normal_label

FROM reports;



/* ==========================================
10. Disease Distribution
========================================== */

SELECT
    SUM(
        CASE
            WHEN LOWER(COALESCE(impression, findings,''))
            LIKE '%pneumonia%'
            AND LOWER(COALESCE(impression, findings,''))
            NOT LIKE '%no%pneumonia%'
            THEN 1 ELSE 0
        END
    ) AS pneumonia_total,

    SUM(
        CASE
            WHEN LOWER(COALESCE(impression, findings,''))
            LIKE '%effusion%'
            AND LOWER(COALESCE(impression, findings,''))
            NOT LIKE '%no%effusion%'
            THEN 1 ELSE 0
        END
    ) AS effusion_total,

    SUM(
        CASE
            WHEN LOWER(COALESCE(impression, findings,''))
            LIKE '%fracture%'
            AND LOWER(COALESCE(impression, findings,''))
            NOT LIKE '%no%fracture%'
            THEN 1 ELSE 0
        END
    ) AS fracture_total,

    SUM(
        CASE
            WHEN LOWER(COALESCE(impression, findings,''))
            LIKE '%mass%'
            AND LOWER(COALESCE(impression, findings,''))
            NOT LIKE '%no%mass%'
            THEN 1 ELSE 0
        END
    ) AS mass_total

FROM reports;