SELECT
  hcpcs_code,
  hcpcs_description,
  COUNT(DISTINCT npi) AS active_providers,
  SUM(line_srvc_cnt) AS total_services_rendered,
  ROUND(AVG(average_submitted_chrg_amt), 2) AS avg_submitted_charge,
  ROUND(AVG(average_medicare_allowed_amt), 2) AS avg_medicare_allowed
FROM `bigquery-public-data.cms_medicare.physicians_and_other_supplier_2015`
WHERE
  nppes_provider_state = 'IL'
  AND hcpcs_code IN (
      'A0434', 'A0425', 'A0888', 'A0426', 'A0390', 'A0398', 
      'A0428', 'A0429', 'A0380', 'A0382', 'A0433', 'A0422', 
      'A0424', 'A0394', 'A0420', 'E0450', 'A4483', 'A4618', 
      'A0427'
    )
GROUP BY
  1, 2
ORDER BY total_services_rendered DESC;