WITH provider_level_calcs AS (
  SELECT
    npi,
    nppes_provider_last_org_name AS organization_name,
    hcpcs_code,
    hcpcs_description,
    average_submitted_chrg_amt AS submitted_charge,
    average_medicare_allowed_amt AS medicare_allowed,
    SAFE_DIVIDE(average_submitted_chrg_amt, average_medicare_allowed_amt) AS charge_multiplier
  FROM
    `bigquery-public-data.cms_medicare.physicians_and_other_supplier_2015`
  WHERE
    nppes_provider_state = 'IL'
    AND average_medicare_allowed_amt > 0
    AND hcpcs_code IN (
        'A0434', 'A0425', 'A0888', 'A0426', 'A0390', 'A0398', 
        'A0428', 'A0429', 'A0380', 'A0382', 'A0433', 'A0422', 
        'A0424', 'A0394', 'A0420', 'E0450', 'A4483', 'A4618', 
        'A0427'
    )
)
SELECT
  hcpcs_code,
  hcpcs_description,
  COUNT(npi) AS provider_count,
  ROUND(AVG(charge_multiplier), 2) AS avg_charge_multiplier,
  ROUND(MIN(charge_multiplier), 2) AS min_charge_multiplier,
  ROUND(MAX(charge_multiplier), 2) AS max_charge_multiplier
FROM
  provider_level_calcs
GROUP BY
  hcpcs_code,
  hcpcs_description
ORDER BY
  avg_charge_multiplier DESC;