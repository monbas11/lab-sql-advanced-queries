-- list each pair of actors that have worked together

select distinct
    film.title as film_title,
    actor1.first_name as actor1_first_name,
    actor1.last_name as actor1_last_name,
    actor2.first_name as actor2_first_name,
    actor2.last_name as actor2_last_name
from film_actor as fa1
join film_actor as fa2 on fa1.film_id = fa2.film_id 
and fa1.actor_id < fa2.actor_id
join actor as actor1 on fa1.actor_id = actor1.actor_id
join actor as actor2 on fa2.actor_id = actor2.actor_id
join film on fa1.film_id = film.film_id;


-- for each film, list actor that has acted in more films

with FilmActor_Count as (
    select
        fa.film_id,
        a.actor_id,
        a.first_name,
        a.last_name,
        COUNT(*) as film_count,
        row_number() over(partition by fa.film_id order by count(*) desc) as rn
    from film_actor fa
    join actor a on fa.actor_id = a.actor_id
    group by fa.film_id, a.actor_id, a.first_name, a.last_name
)
select
    f.title as film_title,
    fac.first_name as actor_first_name,
    fac.last_name as actor_last_name
from film f
join FilmActor_Count fac on f.film_id = fac.film_id and fac.rn = 1;
