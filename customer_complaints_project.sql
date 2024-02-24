-- Financial Consumer Complaints Data Analysis
-- by Sujung Choi

-- display the first 5 rows
select *
from consumer_complaints
order by `Date submitted`
limit 5;

-- Display total number of complaints per date.
select `Date submitted`, count(`complaint ID`) as num_complaints
from consumer_complaints
group by `Date submitted`
order by `Date submitted`;

-- Find the average of the number of complaints per day.
-- Result: on average, there are 27.09 complaints submitted per day.
select avg(num_complaints) as avg_num_complaints_per_day
from (
	select `Date submitted`, count(distinct `complaint ID`) as num_complaints
	from consumer_complaints
	group by `Date submitted`
) as daily_counts;

-- Find number of complaints per year to see if there is any pattern or trends.
-- Result: the number of complaints has continually increased every year.
select extract(year from `Date submitted`) as extracted_year, count(*) as num_complaints
from consumer_complaints
group by extracted_year
order by extracted_year;

-- To further investigate, check if it contains all data for 2017.
-- Result: it is found that the data starts from May 2017, so it does not include the data for January through April.
select extract(month from `Date submitted`) as extracted_month, extract(year from `Date submitted`) as extracted_year, count(*) as num_complaints
from consumer_complaints
group by extracted_month, extracted_year
having extracted_year = 2017
order by extracted_month;

-- Check if it contains all data for 2023
-- result: it is found that the data includes only up to August 2023, so it does not include the data for September through December
select extract(month from `Date submitted`) as extracted_month, extract(year from `Date submitted`) as extracted_year, count(*) as num_complaints
from consumer_complaints
group by extracted_month, extracted_year
having extracted_year = 2023
order by extracted_month;

-- before creating a view, drop the view if it exists already
drop view if exists consumer_complaints_2018_to_2022;

-- create a view that contains only from 2018 to 2022 to use for further analysis requiring all information throughout the years
create view consumer_complaints_2018_to_2022 as
select *
from consumer_complaints
where extract(year from `Date submitted`) between 2018 and 2022;

-- check again for the years 2018 to 2022 to see the number of complaints for each year
-- result: The count increases from 7872 in 2018 to 12953 in 2022, indicating an overall upward trend in the number of complaints over these years.
-- While there was a slight decrease in the number of complaints in 2019 (7075 compared to 7872 in 2018), the subsequent years exhibit 
-- a noticeable increase, reaching the highest count in 2022.
select extract(year from `Date submitted`) as extracted_year, count(*) as num_complaints
from consumer_complaints_2018_to_2022
group by extracted_year
order by extracted_year;

-- find number of complaints per the day of week and rank them to see when people tend to submit the complaints
-- result: people submit the complaints on Tuesday (9167) the most, followed by Wednesday (8860) and Thursday (8361).
-- On the other hand, people submit the complaints the least on Sunday (2448).
select date_format(`Date submitted`, '%a') as day_of_week, count(*) as num_complaints
from consumer_complaints_2018_to_2022
group by day_of_week
order by num_complaints desc;

-- find number of complaints per month and rank them in descending order
-- result: April and August exhibit the highest complaint volumes, with April slightly leading at 4328 complaints, 
-- closely followed by August with 4301 complaints.
-- but the numbers are not significantly different over months, so there is no strong seasonality
-- March-April, and August-October are slightly worse than other seasons, but the range of difference with the lowest months are <900
select extract(month from `Date submitted`) as extracted_month, count(*) as num_complaints
from consumer_complaints_2018_to_2022
group by extracted_month
order by num_complaints desc;

-- find through which method people submit
-- result: People submit complaints via Referral, Web, Phone, Postal mail, Web Referral, Fax, and Email
-- Web is the most commonly used way to submit the complaints (45423), followed by Referral (10766)
-- whereas Web Referral (90) and Email (2) is rarely used
select `Submitted via`, count(*) as num_submit
from consumer_complaints
group by `Submitted via`
order by num_submit desc;

-- Find the number of complaints submitted per state.
-- result: CA, FL, TX, and NY have the highest number of complaints, which is in line with the population ratio.
-- There are no distinctive unusual patterns, indicating that the distribution of complaints aligns with the population ratio per state.
select State, count(*) as num_submit
from consumer_complaints
group by State
order by num_submit desc;

-- The difference of the days (i.e., duration of the days it takes) between the CFPB received the complaint and sent the complaint to the company
-- i.e., how long it takes for the customer's complaints to reach to Bank of America
-- The ranges are broad from 0 to 275 days but the majority is within two weeks (14 days)
select DATEDIFF(`Date received`, `Date submitted`) as days_difference, count(*) as num_count
from consumer_complaints
group by days_difference
order by days_difference;

-- Overall, the average days it takes is 1.2249 days
select avg(DATEDIFF(`Date received`, `Date submitted`)) as days_difference
from consumer_complaints;

-- count how many null values each column contains 
-- (the data contains empty strings instead of nulls, so here it is checking the empty strings)
select sum(case when `Submitted via` = '' then 1 else 0 end) as submit_via_null_count,
        sum(case when `Date submitted` = '' then 1 else 0 end) as date_submit_null_count,
        sum(case when `Date received` = '' then 1 else 0 end) as date_receive_null_count,
        sum(case when State = '' then 1 else 0 end) as state_null_count,
        sum(case when Product = '' then 1 else 0 end) as product_null_count,
        sum(case when `Sub-product` = '' then 1 else 0 end) as subproduct_null_count,
		sum(case when Issue = '' then 1 else 0 end) as issue_null_count,
        sum(case when `Sub-issue` = '' then 1 else 0 end) as subissue_null_count,
        sum(case when `Company public response` = '' then 1 else 0 end) as public_response_null_count,
        sum(case when `Company response to consumer` = '' then 1 else 0 end) as company_response_null_count,
        sum(case when `Timely response?` = '' then 1 else 0 end) as timely_response_null_count
from consumer_complaints;

-- find the products that receives the most complaints and the most common issues regarding that products.
-- result: the product that receive the most complaints (12526) was 'Checking account' and the issue was primarily associated with 'Managing an account'.
-- second highest product (4404) was 'General-purpose credit card or charge card' and its common issue was
-- related to 'Problem with a purchase shown on your statement'.
-- the third highest product (4011) was 'Credit reporting' with a main issue related to 'Incorrect information on your report'.
-- As the most common banking service people uses is the checking account, it is understandable to see that 'checking account' product 
-- has outstanding number of complaints above anything else.  
select Product, `Sub-product`, Issue, count(*) as complaint_count
from consumer_complaints
group by Product, `Sub-product`, Issue
order by complaint_count desc;

-- to further investigate, rank the Product-Issue from the highest to lowest
-- so it first ranks each bigger category of product that received the most complaints
-- and for each product, it ranks the issues related to that product
with product_rank as
(
	select Product, rank() over (order by count(*) desc) as product_rank
	from consumer_complaints
	group by Product
),
issue_rank as
(
	select Product, Issue, count(*) as complaint_count, rank() over (partition by product order by count(*) desc) as issue_rank
	from consumer_complaints
    	group by Product, Issue
)
select pr.Product, ir.Issue, ir.complaint_count, pr.product_rank, ir.issue_rank
from product_rank pr
join issue_rank ir on pr.Product = ir.Product
order by pr.product_rank, ir.issue_rank;

-- find company's public response.
-- result: The majority cases (60311), Bank of America chose not to provide a public response and it solved with the consumer and CFPB directly
-- there are only few cases that the company provide public response and those are mainly when the company believes they were not the problem.
-- for example, company's action was appropriate according to the law, the problem was caused by external factors, or consumer's misunderstanding. 
-- it might be worth taking deeper analysis whether "not providing public response" has not had any downsides to the company
select `Company public response`, count(*) as num_response
from consumer_complaints
group by `Company public response`
order by num_response;

-- find Bank of America's response to consumer and number of times it responded in that particular way
-- result: it shows most of the time they closed with explanation (41044) or with monetary relief (14697).
select `Company response to consumer`, count(*) as num_response
from consumer_complaints
group by `Company response to consumer`
order by num_response;

-- find whether Bank of America is responding in a timely manner to address the issues.
-- Note: According to CFPB, the criteria for "timeply responses" is based on the final response period of 60 days
-- from the date the company received a complaint.
-- Also, the 'Timely response?' column is marked to be Yes or No by CFPB after the company gave a response.
-- result: the majority answered Yes to the 'Timely response?' (58619),
-- which is positive result showing Bank of America address issues with responsibility.
select `Timely response?`, count(*) as count_response
from consumer_complaints
group by `Timely response?`;

-- In the result of above query, we noticed there are also 1494 nulls in the 'Timely response?'
-- to further investigate, find the "In progress" status in `Company response to consumer` column. 
-- result: it shows that the empty rows in 'timely response?' are matching with them,
-- which explains why there were missing values (because it is still in progress)
select `Company response to consumer`, `Timely response?`, count(*) as num_response
from consumer_complaints
group by `Company response to consumer`, `Timely response?`
having `Company response to consumer` = 'In progress';

-- check whether there are any patterns between the products and issues that company tend to respond late
-- result: It does not appear to have distinctive relations for the late response of the company with certain products and issues.
-- the number of products and issues that company respond late shows no difference from the overall number of products and issues 
-- that they typically receive the most complaints in general.
-- therefore, we cannot conclude that there is specific products that leads the late responses over the others.
select Product, `Company response to consumer`, count(*) as num_response
from consumer_complaints
where `Timely response?` = 'No'
group by Product, `Company response to consumer`
order by num_response desc;

-- check how many number of late response occurred each year. 
-- result: it shows increasing pattern of the late response. In particular, in 2021, it has the
-- largest number of late response (1224). Then it goes down to 560 in 2022, which can show
-- Bank of America is trying to get better at the timeliness. However, in 2023 again, 
-- there are already 529 late responses by August.
select extract(year from `Date received`) as extracted_year, count(*) as num_late_response
from consumer_complaints
where `Timely response?` = 'No'
group by extracted_year
order by extracted_year;

-- find the last part of the dataset by ordering them according to `Date received` column.
-- result: the latest complaint's date received in this dataset is August 28, 2023. 
-- Given that CFPB publishes the data only after company responds or after 15 days, whichever comes first, 
-- we can assume the data was extracted around September 14th.
select *
from consumer_complaints
order by `Date received` desc
limit 5;

-- find the number of complaints that are 'In progress' and see how long those complaints have been taken so far.
-- result: by the time the data was extracted in September 2023, the ones in the status of "In progress"
-- were already received by Bank of America in between June through August. 
-- (June: 21, July: 836, August: 637)
-- as CFPB considers timeliness to be within 60 days from the date the company received complaints,
-- some of these "in progress" status would be marked late responses in the end.
select `Company response to consumer`, extract(month from `Date received`) as extracted_month, 
		extract(year from `Date received`) as extracted_year, count(*) as num_complaints
from consumer_complaints
group by `Company response to consumer`, extracted_month, extracted_year
having `Company response to consumer` = 'In progress'
order by extracted_month;

-- assuming the data was extracted in September 14th, 60 days prior to that point is July 16th.
-- thus, filter the "In progress" status in between June 1st to 15th to see those that will be most likely 
-- marked as late response.
select `Company response to consumer`, 
		extract(year from `Date received`) as extracted_year, 
		extract(month from `Date received`) as extracted_month, 
        extract(day from `Date received`) as extracted_day,
        count(*) as num_complaints
from consumer_complaints
where `Company response to consumer` = 'In progress' 
		and `Date received` between '2023-06-01' and '2023-07-15'
group by `Company response to consumer`, extracted_year, extracted_month, extracted_day
order by extracted_month, extracted_day;

-- by summing them up, we can get the total complaints of the above query.
-- result: it shows 378 complaints were received by Bank of America between June 1st and July 15th 
-- that are still in progress. As they are expected to be labeled as late responses in the end, 
-- they will increase the overall number of late responses in 2023,
-- combining with confirmed 529 late responses we found in the previous queries.
-- In conclusion, it indicates Bank of America would not do better in terms of timeliness in 2023 than 2022
-- (In 2022, the number of late responses were 560)
select count(*) as total_complaints
from consumer_complaints
where `Company response to consumer` = 'In progress' 
		and `Date received` between '2023-06-01' and '2023-07-15';
