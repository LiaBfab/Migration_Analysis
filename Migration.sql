/* Defining the database to use and reading the table */

USE skilled_migration;
select * from skill_migration_public;

/* Question 1a: Analyze the trends in skilled migration by summarizing the net migration per 10k population for each skill_group_category 
by wb_region from 2015 - 2019.*/

select skill_group_category, wb_region, 
AVG((net_per_10K_2015 + net_per_10K_2016 + net_per_10K_2017 + net_per_10K_2018 + net_per_10K_2019) / 5) AS Average_Net_Migration 
from skill_migration_public
group by skill_group_category, wb_region
order by Average_Net_Migration; 

/* Question 1b: Identify which region had the highest net migration for Tech Skills in 2019  */

select wb_region, sum(net_per_10K_2019) as total_net_migration from skill_migration_public
where skill_group_category = 'Tech Skills'
group by wb_region
order by total_net_migration
limit 1;  

/* Question 2: Identify the top 10 countries with the highest total net migration in 2019. */

SELECT country_name, sum(net_per_10K_2019) as total_net_migration_2019, abs(sum(net_per_10K_2019)) as Absolute_Net_Migration
FROM skill_migration_public
GROUP BY country_name
order by Absolute_Net_Migration DESC
LIMIT 10;

# Venezuela, Luxembourg, and Germany are among the top countries with significant net migration figures. The data highlights both
# positive and negative net migration, indicating countries with high immigration (e.g. Luxembourg, ) and emigration (e.g., Venezuela).

/* Question 3a: Generating a report on the average net migration rate for each wb_income group by skill_category(2015 - 2019)*/

SELECT 
    wb_income,
    skill_group_category,
    AVG(net_per_10K_2015 + net_per_10K_2016 + net_per_10K_2017 + net_per_10K_2018 + net_per_10K_2019) AS Average_Net_Migration
FROM
    skill_migration_public
GROUP BY wb_income , skill_group_category; 


/* Question 3b: Generating a report on the Lowest average net migration rate for all wb_income group by skill_category(2015 - 2019) */

SELECT 
    wb_income,
    skill_group_category,
    AVG(net_per_10K_2015 + net_per_10K_2016 + net_per_10K_2017 + net_per_10K_2018 + net_per_10K_2019)
    AS Average_Net_Migration,
    ABS(AVG(net_per_10K_2015 + net_per_10K_2016 + net_per_10K_2017 + net_per_10K_2018 + net_per_10K_2019))
    AS Absolute_Average_Net_Migration
FROM
    skill_migration_public
GROUP BY wb_income , skill_group_category
ORDER BY Absolute_Average_Net_Migration
LIMIT 1; 

/* Question 4a: Write an SQL query to find the difference in net migration rates between Tech Skills and Business Skills for each country
and year. Identify which country had the highest difference in 2019 */

SELECT country_name, tech_net_migration, business_net_migration,
          (tech_net_migration - business_net_migration) AS migration_difference
   FROM (
         SELECT country_name, 
                sum(CASE WHEN skill_group_category = 'Tech Skills' THEN net_per_10K_2019 ELSE 0 END) AS tech_net_migration,
                sum(CASE WHEN skill_group_category = 'Business Skills' THEN net_per_10K_2019 ELSE 0 END) AS business_net_migration
         FROM skill_migration_public
         GROUP BY country_name
        ) AS casequery
   ORDER BY migration_difference DESC;

/* Question 4b: Identify which country had the highest difference in net migration rates between Tech Skills and Business Skills for 2019. */
SELECT country_name, tech_net_migration, business_net_migration,
          (tech_net_migration - business_net_migration) AS migration_difference,
          ABS(tech_net_migration - business_net_migration) AS absolute_migration_difference
   FROM (
         SELECT country_name, 
                sum(CASE WHEN skill_group_category = 'Tech Skills' THEN net_per_10K_2019 ELSE 0 END) AS tech_net_migration,
                sum(CASE WHEN skill_group_category = 'Business Skills' THEN net_per_10K_2019 ELSE 0 END) AS business_net_migration
         FROM skill_migration_public
         GROUP BY country_name
        ) AS casequery
   ORDER BY absolute_migration_difference DESC
   LIMIT 1;

/* Question 5a: How does the net profit vary across different income groups (e.g. low income, high income)? */

SELECT wb_Income, AVG(net_per_10K_2015 + net_per_10K_2016 + net_per_10K_2017 + net_per_10K_2018 + net_per_10K_2019) AS avg_net_profit
FROM skill_migration_public
GROUP BY wb_Income;

/* Question 5b: What are the trends in net profit across different regions (e.g., South Asia, Europe)? */

SELECT wb_region, SUM(net_per_10K_2015 + net_per_10K_2016 + net_per_10K_2017 + net_per_10K_2018 + net_per_10K_2019) AS total_net_profit
FROM skill_migration_public
GROUP BY wb_region;

/* Question 6:  How do different skill categories (e.g. Tech Skills, Business Skills e.t.c) affect net profit over the years? */

SELECT skill_group_name, AVG(net_per_10K_2015 + net_per_10K_2016 + net_per_10K_2017 + net_per_10K_2018 + net_per_10K_2019) AS avg_net_profit
FROM skill_migration_public
GROUP BY skill_group_name;
