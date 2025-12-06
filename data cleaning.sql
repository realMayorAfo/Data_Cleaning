-- Data cleaning

select *
from layoffs;

-- Duplicate

create Table layoffs2_staging
like layoffs;

select *
from layoffs2_staging;
 
 insert layoffs2_staging
 select *
 from layoffs;

select*,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, 'date' ) as row_num
from layoffs2_staging;

with duplicate_cte as (
select*,
row_number() over( partition by company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
from layoffs2_staging
)
select *
from duplicate_cte
where row_num > 1;

select *
from layoffs2_staging
where company = 'casper';

select*,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, 'date' ) as row_num
from layoffs2_staging;

with duplicate_cte as (
select*,
row_number() over( partition by company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
from layoffs2_staging
)
delete
from duplicate_cte
where row_num > 1;

create table layoffs2_staging2 (
company text, 
location text,
industry text, 
total_laid_off int, 
percentage_laid_off text, 
date text ,
stage text ,
country text ,
funds_raised_millions int,
row_num int
) ENGINE =InnoDB DEFAULT CHARSET= utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs2_staging2;

insert into layoffs2_staging2
select*,
row_number() over( partition by company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
from layoffs2_staging;

delete
from layoffs2_staging2
WHERE row_num > 1;

select *
from layoffs2_staging2;

-- Standardizing data

select company, trim(company)
from layoffs2_staging2;

update layoffs2_staging2
set company = trim(company);

select distinct industry
from layoffs2_staging2
order by 1;

select *
from layoffs2_staging2
where industry like 'crypto%';

update layoffs2_staging2
set industry = 'crypto'
where industry like 'crypto%';

select*
from layoffs2_staging2;

select distinct location
from layoffs2_staging2
order by 1;

select distinct country
from layoffs2_staging2
order by 1;

update layoffs2_staging2
set country = 'United states'
where country like 'United states%';

-- change the date from text to date form
select date,
str_to_date(date, '%m/%d/%Y')
from layoffs2_staging2;

update layoffs2_staging2
set date = str_to_date(date, '%m/%d/%Y');

select *
from layoffs2_staging2;

alter table layoffs2_staging2
modify column `date` DATE;

-- removing null or blank vales

select *
from layoffs2_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;

update layoffs2_staging2
set industry = null
where industry = '';

select*
from layoffs2_staging2
where industry is NULL
OR industry = '';

select *
from layoffs2_staging2
where company = 'Airbnb';

select t1.industry , t2.industry
from layoffs2_staging2 t1
join layoffs2_staging2 t2
	on t1.company = t2.company
    
where (t1.industry is NULL )
and t2.industry is not NULL;

update layoffs2_staging2 t1
join layoffs2_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is NULL )
and t2.industry is not NULL;

select *
from layoffs2_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;

delete
from layoffs2_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;

select *
from layoffs2_staging2;

alter table layoffs2_staging2
drop column row_num;










