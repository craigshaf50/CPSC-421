create procedure person_insert
(@person_name varchar(500))
as
Begin
    insert into person
    (
    person_id,
    person_name
    )
    select
    max(person_id)+1,
    @person_name
    from person;
end;
exec person_insert 'Craig Shaffer'