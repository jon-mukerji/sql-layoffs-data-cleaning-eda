-- layoffs

select*
from layoffs;

-- Remove Duplicates
-- Standardize the Data
-- Null Values or blank values
-- Remove Any columns or rows

-- create table
create table layoff_staging
like layoffs;

Select *
from layoff_staging;

insert layoff_staging
select *
from layoffs;

-- identify duplicates

select *,
row_number() over(partition by company, industry, total_laid_off, percentage_laid_off, date) as row_num
from layoff_staging;

with duplicate_cte as (
select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`,stage, country, funds_raised_millions) as row_num
from layoff_staging
) 
select *
from duplicate_cte
where row_num > 1
;

select *
from layoff_staging
where company = 'Casper' ;

with duplicate_cte as (
select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`,stage, country, funds_raised_millions) as row_num
from layoff_staging
) 
Delete
from duplicate_cte
where row_num > 1;

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoff_staging2
where row_num > 1;

insert into layoff_staging2
select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`,stage, country, funds_raised_millions) as row_num
from layoff_staging;

select *
from layoff_staging2
where row_num > 1;

DELETE
from layoff_staging2
where row_num > 1;

select *
from layoff_staging2;

-- Standardizing data 
Select (company), trim(company)
from layoff_staging2;

-- Updating the data
update layoff_staging2
set company = trim(company);

Select distinct industry
from layoff_staging2
;
 

Update layoff_staging2
set industry = 'Crypto'
where industry like 'crypto%';

Select distinct country
from layoff_staging2
order by 1;

select country
from layoff_staging2
where country like 'United states.';

Update layoff_staging2
set country = "United States"
where country like 'United states.';

Select *
from layoff_staging2
;

select `date`,
str_to_date( `date`, '%m/%d/%Y')
from layoff_staging2;

update layoff_staging2
set `date` = str_to_date( `date`, '%Y/%m/%d');

Alter table layoff_staging2
modify column `date` DATE;

SELECT DISTINCT `date`
FROM layoff_staging2
LIMIT 20;

select *
from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null;

Update layoff_staging2
set industry = null
where industry = '';

select *
from layoff_staging2
where industry is null
or industry = '';

select *
from layoff_staging2
where company = 'airbnb';

select t1.industry, t2.industry
from layoff_staging2 as t1
join layoff_staging2 as t2
	on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;
    
update layoff_staging2 as t1
join layoff_staging2 as t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

select *
from layoff_staging2;

select *
from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null;


alter table layoff_staging2
drop column row_num;

select *
from layoff_staging2;
