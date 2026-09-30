WITH provider_variances AS (
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
      'A0427', 'A0428', 'A0429', 'A0433', 'A0434'
    )
)
SELECT
  npi,
  organization_name,
  hcpcs_code,
  submitted_charge,
  medicare_allowed,
  ROUND(charge_multiplier, 2) AS charge_multiplier,
  ROUND(PERCENTILE_CONT(charge_multiplier, 0.90) OVER (PARTITION BY hcpcs_code), 2) AS p90_threshold
  FROM
    provider_variances
  QUALIFY
    charge_multiplier >= PERCENTILE_CONT(charge_multiplier, 0.90) OVER (PARTITION BY hcpcs_code)
  ORDER BY
    hcpcs_code,
    charge_multiplier DESC;