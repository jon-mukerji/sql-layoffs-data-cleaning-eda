-- Exploratory Data Analysis

select *
from layoff_staging2;

-- Retrieving maximum lay-off in one day and percentage of the company laid-off
select MAX(total_laid_off), max(percentage_laid_off)
from layoff_staging2;

-- Retrieving companies that completely went down, laying-off 100%
select *
from layoff_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

-- Retrieving companies that laid-off the whole company yet raised funds in billion
select *
from layoff_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

-- Grouping by companies and their total laid-off
select company, sum(total_laid_off)
from layoff_staging2
group by company
order by 2 desc;

-- Time Interval during this laid-off
select min(`date`), max(`date`)
from layoff_staging2;

-- Grouping by Industry against total laid-off
select industry, sum(total_laid_off)
from layoff_staging2
group by industry
order by 2 desc;

-- Grouping by the country which had the most laid-off
select country, sum(total_laid_off)
from layoff_staging2
group by country
order by 2 desc;

-- Grouping by date which had the most laid-off
select Year(`Date`), sum(total_laid_off)
from layoff_staging2
group by Year(`Date`)
order by 1 desc;

-- Stage of the companies that went-off 
select stage, sum(total_laid_off)
from layoff_staging2
group by stage
order by 2 desc;

-- retrieving laiy-offs moth-wise 
select substring(`date` ,1,7) as `Month`, sum(total_laid_off)
from layoff_staging2
where substring(`date` ,1,7) is not null
group by `Month`
order by 1 asc;

-- Rolling total of lay-off's year-month wise
with Rolling_total as 
(
select substring(`date` ,1,7) as `Month`, sum(total_laid_off) as total_off
from layoff_staging2
where substring(`date` ,1,7) is not null
group by `Month`
order by 1 asc
)
select `month`, total_off,
sum(total_off) over(order by `month` ) as rolling_total
from Rolling_total;


-- Grouping by companies that went-off year-wise
select company, Year(`Date`), sum(total_laid_off)
from layoff_staging2
group by company, Year(`Date`)
order by 3 desc;

-- Ranking per-year top 5 company lay-offs
with Company_year(company, years, total_laid_off) as 
(
select company, Year(`Date`), sum(total_laid_off)
from layoff_staging2
group by company, Year(`Date`)
), Company_year_rank as
(
select *, 
dense_rank() over(partition by years order by total_laid_off desc) as Ranking
from Company_year
where years is not null
)
select *
from Company_Year_Rank
where Ranking <= 5
;




