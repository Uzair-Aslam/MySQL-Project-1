-- Exploratory Data Analysis (EDA) from March 11th 2020 to March 6th 2023

SELECT * 
FROM layoffs_staging2;


SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Maximum number of employees laid off by a company per industry

SELECT industry, MAX(total_laid_off) AS max_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY MAX(total_laid_off) DESC;

-- Total number of employees laid off by industry

SELECT industry, SUM(total_laid_off) AS sum_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC;

-- Companies that completely went under

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1;

-- Companies with the most laid off that also went under

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Companies with the most laid off

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC;

-- Countries with the most layoffs

SELECT country, SUM(total_laid_off) AS sum_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY SUM(total_laid_off) DESC;

-- Companies that raised the most funds

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Date ranges

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Total layoffs per year

SELECT YEAR(`date`), SUM(total_laid_off) AS sum_laid_off
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY YEAR(`date`) DESC;

-- Total layoffs by the stage the company is in

SELECT stage, SUM(total_laid_off) AS sum_laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY stage DESC;

-- Total layoffs by month each year

SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY  `Month`
ORDER BY `Month` ASC;

-- Rolling sum of layoffs by each month per year using CTE

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY  `Month`
ORDER BY `Month` ASC
)
SELECT `Month`, total_off,
	SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_Total;    

-- Rolling total by company per year

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC;

SELECT company, YEAR (`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC;

-- Ranked total laid off by company by year

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR (`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS   -- Second CTE
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE Ranking <= 5;












