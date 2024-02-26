# Bank of America Consumer Complaints Data Analysis

In this personal project, I utilized MySQL to analyze consumer complaints data concerning Bank of America's products and services. The dataset includes complaints submitted to the Consumer Financial Protection Bureau (CFPB) from 2017 to 2023. \
🌼 Dataset Link: [Maven Analytics](https://www.mavenanalytics.io/data-playground)


## Dataset Description:

![image](https://github.com/Su-Jung-Choi/consumer_complaints_project/assets/88897881/6db4d57a-cb78-41b6-a95d-77f690282450)

**The main objectives were to 1) analyze the yearly pattern of complaint numbers, 2) identify products with the highest number of complaints and their corresponding common issues, and 3) assess the timeliness of the bank's responses.**

1. To uncover the yearly pattern of complaints, I extracted the year from the 'Date submitted' column and counted the number of complaints. Upon reviewing the data from 2017 to 2023, I observed entries starting from May 2017 and extending to August 2023. Consequently, I excluded 2017 and 2023 due to incomplete full-year data. The results below reveal an increasing pattern in the number of complaints from 2018 to 2022.
Notably, 2019 marked the year with the lowest number of complaints, which is a positive indicator. It may be worth delving into how and why the bank received fewer complaints in 2019 and considering strategies to replicate that success. Furthermore, given the significant recent increase in complaint numbers, understanding the root causes behind this increase is important.
  
![yearly_num_complaints](https://github.com/Su-Jung-Choi/consumer_complaints_project/assets/88897881/8a88dafa-c56a-40ed-bbe8-2ceb32eb996d)




2. In identifying the products with the highest number of complaints and their most common issues, I utilized the 'Product,' 'Sub-product,' and 'Issue' columns. I grouped them together to calculate the complaint counts. The findings reveal that the 'checking account' product, particularly associated with an issue regarding 'Managing an account,' received the highest number of complaints. Following closely is the product 'General-purpose credit card or charge card' paired with an issue related to 'Problem with a purchase shown on your statement'. 

![product_issue](https://github.com/Su-Jung-Choi/consumer_complaints_project/assets/88897881/369274b8-4458-4771-a9f2-85a933bb1d4c) 


3. To assess Bank of America's responsiveness to consumer complaints, I counted the responses based on the 'Timely response?' column and calculated the corresponding percentages. The results indicate that approximately 93.77% of responses were timely, 3.84% were not timely, and the remaining 2.39% were still in progress at the time of analysis. This outcome suggests that Bank of America is effectively addressing issues with a high level of responsibility. 

- Note: The 'Timely response?' column is marked as Yes or No by the CFPB after the company provides a response. According to the [CFPB](https://www.consumerfinance.gov/data-research/research-reports/2022-consumer-response-annual-report/), companies are expected to respond within 60 days from the date of receiving a complaint to be considered timely. Responses received after this period are categorized as not timely. 


![company_public_response](https://github.com/Su-Jung-Choi/consumer_complaints_project/assets/88897881/eec86868-0f90-430f-bf02-6969868a57d1) 


> [!NOTE]
> For the detailed exploration of the data and results, check out the 'customer_complaints_project.sql' file.
> I also created a dashboard using Tableau, including the key findings from this data analysis.
> To view and interact with the Tableau dashboard, visit [here](https://public.tableau.com/app/profile/sujung.choi/viz/customer_complaints_17088190139230/Dashboard1)
