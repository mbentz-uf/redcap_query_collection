-- Generate the project billing record

-- email_contacts_for_uf_valued_projects.csv
select rcp.project_id, rcp.app_title, rcp.creation_time,
       ufpo.firstname as owner_firstname, ufpo.lastname as owner_lastname, ufpo.email as owner_email,
       project_pi_firstname, project_pi_lastname, project_irb_number,
       ufpo.firstname as project_user_firstname, ufpo.lastname as project_user_lastname, ufpo.email as project_user_email_address
from redcap_projects as rcp
inner join uf_valued_projects as ufvp on (rcp.project_id = ufvp.project_id)
left join uf_project_ownership as ufpo on (rcp.project_id = ufpo.project_id)
where ufpo.email is not NULL
UNION
select rcp.project_id, rcp.app_title, rcp.creation_time,
       ufpo.firstname as owner_firstname, ufpo.lastname as owner_lastname, ufpo.email as owner_email,
       project_pi_firstname, project_pi_lastname, project_irb_number,
       rcui.user_firstname as project_user_firstname, rcui.user_lastname as project_user_lastname, rcui.user_email as project_user_email_address
from redcap_projects as rcp
inner join uf_valued_projects as ufvp on (rcp.project_id = ufvp.project_id)
left join redcap_user_rights as rcur on (rcp.project_id = rcur.project_id)
inner join redcap_user_information as rcui on (rcur.username = rcui.username)
left join uf_project_ownership as ufpo on (rcp.project_id = ufpo.project_id)
where
    rcui.user_suspended_time is null
    and datediff(now(), rcui.user_lastlogin) < 180
;
