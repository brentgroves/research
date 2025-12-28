# **[Slowly Changing Dimensions](https://www.geeksforgeeks.org/software-testing/slowly-changing-dimensions/)**

## My notes

A price can change and will be different over time and possibly different for every fact record.

Where an OnHand quantity changes with every withdrawal.  You could keep a snapshot of OH quantities every night. If you wanted the change in inventory or you could store the entire transaction history file if it could be linked with the current quantity.

Last Updated : 06 Aug, 2024
Slowly Changing Dimensions (SCD) are a critical concept in data warehousing and business intelligence. They refer to the methods used to manage and track changes in dimension data over time. This is essential for maintaining historical accuracy and ensuring data integrity in a data warehouse.

## What are slowly changing dimensions?

Slowly Changing Dimensions are those parts of the data warehousing structures that change on an irregular basis and not on fixed time intervals. They record and preserve past alterations in data including alterations in the client’s residence or phone contacts. SCDs play a significant role in keeping up-to-date records for analysis, reporting, and decision-making for current and future use. They assist in monitoring the changes of dimensional attributes and guarantee the maintainability of data qualities in case of changing business entities.

## Features of Slowly Changing Dimensions

- Historical Tracking: All types of changes made to stored data in an SCD are retained with history so that trend and historical reports can be created.
- Data Integrity: They ensure the purity of data by enabling change management without decomposition of the data.
- Type-Based Classification: Besides the categorization by connector types, SCDs are also classified into different types based on the management of change (e.g. Type 1, Type 2, Type 3).
- Versioning: In some types of SCDs, new records or new versions are created to hold the history data together with current data such as Type 2.
- Temporal Analysis: They grant time perspective enabling a view of how this data evolves that is crucial for dealing with change or time-series data.

Types of slowly changing dimensions and implementation

![scd](https://media.geeksforgeeks.org/wp-content/uploads/20240805164500/Slowly-Changing-Dimension-types.webp)

- Type 0 (Fixed Dimension)
Description: In the case of Type 0 dimensions, there are no changes whatsoever. The primary uses for static data are when the data does not change over time, for example; states, zip codes, county codes, SSN, and date of birth etc.
Implementation: The records located in these tables are unalterable and no modification can be made to the record.
- Type 1 (Overwrite)
Description: For changes in Type 1 dimensions; overwriting is used where the new value simply replaces the old value that was already stored. Unfortunately, this method does not save any previous data; that is, it cannot illustrate changes over time.
Implementation: When an update happens, then the new value replaces the previous value in the database without any interference. It is applied in situations where the historical data is irrelevant to the task, for example, changing a customer’s current address.
- Type 2 (Add New Row)
Description: Type 2 dimensions are stored in a way that a new record is added every time there is a change but the history is retained. Each time a new record is added, a new surrogate also gets created; however, physical relationships are preserved through the use of natural keys.
Implementation: This can be done by supplementing a flag column (such as _FIVETRAN_DELETED) to determine the active record or through timestamp fields specifying when the record is active or inactive. This method, therefore, enables the tracking of changes over time and is mostly applied to attributes such as product bundles.
Example: In a product dimension table, every change in the product configuration would mean a new row, with a time stamp indicating the validity of the record.
- Type 3 (Add New Attribute)
Description: Type 3 dimensions record changes by adding an attribute that will hold the prior value of an attribute. This technique enables tracking of a few changes only; it is suitable where only the last change needs to be retained.
Implementation: The previous value is saved in a new column with a different name than the one in which the current value is saved (e.g. current_address). This is suitable when charting change that is anticipated to occur periodically for example a change of the warehouse’s physical address.
Example: In the case where a company's warehouse changes, the previous_address column would contain the previous address, while the current_address would contain the new one.
- Type 4 (History Table)
**Description:** Type 4 dimensions employ the use of the Current table and/or the Historical table. The most recent version of the data is stored in one table while all historical data is stored in another table.
**Implementation:** This current data table is updated and the prior information from the current data table is shifted into the history data table. It is suitable where actual data changes within a short period and where details of historical change need to be recorded.
**Example:** This approach can be used in tracking the order information where the history table has records of every action taken on the order for instance addition of items to the cart or removal of items.

How to implement slowly changing dimensions in a data warehouse

![i1](https://media.geeksforgeeks.org/wp-content/uploads/20240805164557/steps-for-implementing-slowly-changing-dimensions-in-a-data-warehouse.webp)

1. Initial Assessment
**Evaluate Current State:** To begin with, one needs to evaluate the state of affairs by defining what dimensions are already presented in the database. Record these dimensions, the kinds of things that define these dimensions, and their orientation.
**Identify Needs:** Establish which of the above-concept dimensions would need historical data collection. If there are some dimensions currently set for the type 0, which should be able to describe changes, these should be prioritized for updates.
2. Decide on SCD Types
**Business Requirements:** Assess the needs of the business that have to do with the use of historical information. It is recommended to consult with data engineers, analytics engineers, and data analysts to determine which SCD types are suitable – Type 1, 2, 3, or 4.
**Implementation Preferences:** Based on the relative frequency of changes and the amount of data that one expects to be historical, choose between flag columns, timestamp columns, and historical tables that are separate.
3. Handling Pre-existing Data
**Historical Data Gaps:** Figure out what to do with data that was not collected before the implementation of a new type of tracking. Options include:
**Build Forward:** Begin tracking changes here; recognise that data before this period will not be truly representative.
**Reconstruct History:** Experimental if possible try to replicate the historical records from record, communication or stakeholders. However, one must be careful and sceptical about the reconstructed data as a historical source.
4. Implementing SCDs
  Schema Design:
  For type 1, records are updated with new data by rewriting the record in the database.
  For Type 2, add new attributes like Start_Date, End_Date, Is_Current and new records should be inserted for change.
  For Type 3, existing columns for tracked attributes should be split for every additional pair of old and new values to be stored.
  For both Type 4, make two tables- one for the current data and the other for the previous data.
  **ETL Processes:** It is necessary to update ETL processes to identify alterations in source data and its processing respecting the chosen SCD type. This might involve:
    - Influence of data about changes in specific feed.
    - Appending records or creating new records in the fact tables and/or inserting records in dimension tables.
    - Some of the responsibilities of the tool include the administration of **surrogate keys** as well as the integrity of the data.
5. Testing and Validation
    **Accuracy Checks:** Perform extensive investigation to ascertain that the changes are well implemented and correctly captured as well as the integrity of the data is upheld.
    **Data Quality:** Data quality should be checked constantly, especially if dealing with reconstructed historical data, or newly tracked data.
6. Documentation and Training
    - **Documentation:** Make precise records of all aspects of the SCD such as data models, the process of extractions, transformations & loads, and other decisions that were made regarding history data.
    - **Training:** Inform the users of data and data analysts of the proper way of analyzing the newly tracked data, especially in cases where new columns or new tables have been added to the data.
7. Ongoing Maintenance
    - **Regular Updates:** Ensure constant synchronization of SCD implementation with companies’ demands and change the ETL processes and data structures if needed.
    - **Performance Monitoring:** Supervise the performance of the SCD implementation, especially when there are extensive amount of data and adjust if possible.

## Techniques for maintaining slowly changing dimensions

1. ETL(Extract, Transform, Load) logic for SCD Maintenance

    - **Bulk Data Extraction:** By now it’s clearly understood that ETL processes are employed mostly for data extraction for processing and subsequently for transformation. This method is most useful for a batch process of update and is frequently adopted in type 3 and type 4 SCD.
    - **Handling Changes:** ETL is efficient when it comes to following alterations since it compares the current data sets with the new data sets. This encompasses the process of adding new records or making changes to records in the dimension tables.
    - **Processing Power and Storage:** ETL is often resource-intensive in terms of the amount of processing power and storage that may be needed especially when working with large databases that are frequently refreshed. But, it offers records and documentation and it has a history of all the executed and recorded tasks.
    - **Audit Trail Creation:** Due to the strategy where ETL makes many records for each modification, it is optimal for tracking history, which is important when working with large amounts of data.
2. Change Data Capture(CDC) for SCD Maintenance
    - **Real-Time Data Tracking:** CDC is a technique that focuses on capturing and tracking changes as and when they occur in real time. This approach is extremely useful in that regard since certain data can become out of date or inaccurate almost instantly in certain contexts.
    - **Critical for Type 2 SCDs:** In the case of Type 2 SCDs, CDC is critical since change operations require new records to be created with history maintained at the same time. This enables every alteration to be recorded while at the same time not erasing the information that had been input previously.
    - **Enabling CDC:** Enabling CDC happens both at the database level and the table levels to use it. This setup guarantees that change is consistent across all tables that might be implemented.
    - **Integration with Ingestion Tools:** CDR such as **[Fivetran](https://www.fivetran.com/)** to improve the data ingestion function and create extra columns, such as FIVETRAN_DELETED and timestamp to conduct the historical data. They make sure changes are documented correctly or a minimum of time is wasted.

3. History Tracking with Effect Dates
    - **Consistent Timestamp Usage:** In cases where time stamping is used to log changes the correct time stamp values must be used and should be consistent with the ones from the data feed. This reduces the chances of a time gap and, therefore, keeps more accurate records of the account's history.
    - **Database-Generated Timestamps:** This is practically preferred if the timestamps are generated by a database such as SQLite to guarantee accuracy. These timestamps should be the true creation time and last modified timestamps of the particular records.
    - **Effective Date Columns:** There is always a validity date; thus, employ fields like Start_Date and End_Date to show that the records are valid for that period only. This method can be effectively used in all the Type 2 SCDs with the primary objective of discriminating current from past information.
4. Updating of data
    - **Regular Updates and Monitoring:** Have a way of updating or placing the data in a system where it’s updated frequently to avoid giving outdated information. This also includes healthy ETL and CDC processes that must be kept in healthy running order at all times.
    - **Strategic SCD Type Selection:** It is advisable to select the proper SCD type for every dimension table regarding business needs and data characteristics. This decision should factor in historical tracking and the frequency of data change.
    - **Facilitating Data-Driven Decisions:** The efficient use of SCDs enables historical analysis, which is critical for informed business decisions because of its richness. It will allow the organization to make measures, forecast, and respond to change consequently.

## Conclusion

In conclusion, there is nothing as important in a data warehouse as Keeping Slowly Changing Dimensions (SCDs) if the organization intends to track past performance accurately, and not make analysis a herculean task. Different types of SCDs and intricate methods like the Hybrid SCDs and Temporal Tables let organizations handle all sorts of data change transactions and become data-driven. When these strategies are well designed and properly used, they result in the accuracy of the data, beyond which the results provide a means for historical review, and support the overall quality of business intelligence.
