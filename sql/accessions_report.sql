SELECT 
    `accession`.id,
    `accession`.title,
    `accession`.identifier,
    `accession`.accession_date, 
    `accession`.condition_description, 
    e1.value AS "aquisition_type",
    e2.value AS "resource_type", 
    `accession`.publish,
    `accession`.access_restrictions,
    `accession`.access_restrictions_note, 
    `accession`.use_restrictions, 
    `accession`.use_restrictions_note, 
    `date`.expression, 
    `date`.begin, 
    `date`.end,
    `extent`.number, 
    `extent`.container_summary, 
    e3.value AS "agent_role_id", 
    `name_person`.sort_name, 
    `agent_contact`.address_1, 
    `agent_contact`.address_2,
    `agent_contact`.address_3,
    `agent_contact`.city,
    `agent_contact`.region,
    `agent_contact`.country,
    `agent_contact`.post_code,
    `agent_contact`.email,
    `agent_contact`.note, 
    `telephone`.number, 
    `resource`.ead_id, 
    `resource`.title AS "resource_title"
FROM `accession`
  LEFT JOIN `date`
    ON `accession`.id = `date`.accession_id
  LEFT JOIN `extent`
    ON `accession`.id = `extent`.accession_id
  LEFT JOIN `linked_agents_rlshp` 
    ON `accession`.id = `linked_agents_rlshp`.accession_id 
  LEFT JOIN `name_person`
    ON `linked_agents_rlshp`.agent_person_id = `name_person`.agent_person_id 
  LEFT JOIN `agent_contact`
    ON `linked_agents_rlshp`.agent_person_id = `agent_contact`.agent_person_id 
  LEFT JOIN `telephone`
    ON `agent_contact`.id = `telephone`.agent_contact_id 
  LEFT JOIN `spawned_rlshp`
    ON `spawned_rlshp`.accession_id=`accession`.id
  LEFT JOIN `resource`
    ON `resource`.id = `spawned_rlshp`.resource_id
  LEFT JOIN `enumeration_value` e1
    ON `accession`.acquisition_type_id=e1.id
  LEFT JOIN `enumeration_value` e2
    ON `accession`.resource_type_id=e2.id
  LEFT JOIN `enumeration_value` e3
    ON `linked_agents_rlshp`.role_id=e3.id;
