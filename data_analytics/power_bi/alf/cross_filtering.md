# **[]()**

Cross filtering in Power BI is the feature that allows you to select a data point in one visual to automatically filter other visuals on the same page, showing only related data. For example, clicking a segment in a bar chart filters a line chart to show data only for that selected bar's category. This is different from cross-highlighting, where data points in other visuals are dimmed but still visible.  

## How it works

- **Default behavior:** By default, visuals on a Power BI report page are set to cross-filter or cross-highlight each other. When you click on a data point, the other visuals update to reflect your selection.
- **Cross-filtering vs. cross-highlighting:**
  - **Cross-filtering:** Hides data that doesn't apply to your selection. Only the related data remains visible.
  - **Cross-highlighting:** Dims the unrelated data, but keeps it visible in the background.
- **Controlling interactions:** Report designers can customize how visuals interact by using the "Edit interactions" feature to change the default behavior from cross-filtering to cross-highlighting, or to turn interactions off entirely.
- **Customizing interaction:** You can change how a specific visual interacts with others by selecting it, going to the "Format" menu, and choosing "Edit interactions".
You can **[watch this video](https://www.youtube.com/watch?v=AwRqIZEwn-Y&t=45)** to learn how to change interactions between visuals in Power BI:

## Changing relationship direction

- **Single vs. Both:** By default, relationships between tables filter in a single direction (e.g., from a "one" side to a "many" side).
- **Bidirectional filtering:** You can enable bidirectional cross-filtering by editing the relationship and setting the "Cross filter direction" to "Both". This allows filters to flow in both directions, which can fix issues like repeated values.
- **DAX function:** The CROSSFILTER DAX function allows you to modify the cross-filter direction for specific calculations without changing the data model itself, which is useful for modifying filter context in DAX expressions.
