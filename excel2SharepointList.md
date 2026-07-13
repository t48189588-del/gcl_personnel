# Script
This script is made to read the Excel file to export data in json format to power automate to save into Sharepoint List 

```
function main(workbook: ExcelScript.Workbook) {

  const ws = workbook.getWorksheet("All");
  if (!ws) throw new Error('Worksheet "All" not found.');

  const used = ws.getUsedRange();
  if (!used) return;

  const firstRow = used.getRowIndex() + 1;
  const firstColumn = used.getColumnIndex() + 1;

  const texts = used.getTexts();

  const header = texts[0];
  const values = texts.slice(1);

  const result: {
    staff: string;
    startTime: string;
    endTime: string;
    value: string;
    color: string;
  }[] = [];

  let currentDate = "";

  for (let a = 0; a < header.length; a++) {

    if (!header[a]) continue;

    for (let b = 0; b < values.length; b++) {

      if (values[b][0]) {
        currentDate = values[b][0];
      }

      if (!values[b][a] || !values[b][2]) continue;

      const row = b + firstRow + 1;
      const column = a + firstColumn;

      const color = ws
        .getCell(row - 1, column - 1)
        .getFormat()
        .getFill()
        .getColor();

      const times = values[b][2].split("-");

      result.push({
        staff: header[a],
        startTime: `${currentDate}T${times[0]}`,
        endTime: `${currentDate}T${times[1]}`,
        value: color ? "approved" : "available",
        color
      });
    }
  }
  const merged: {
    staff: string,
    startTime: string,
    endTime: string,
    color: string,
    value: string
  }[] = [];

  for (const item of result) {
    const last = merged[merged.length - 1];

    if (
      last &&
      last.staff === item.staff &&
      last.value === item.value &&
      last.color === item.color &&
      last.endTime === item.startTime
    ) {
      last.endTime = item.endTime;
    } else {
      merged.push({ 
        staff:item.staff,
        startTime:item.startTime,
        endTime:item.endTime,
        value:item.value,
        color:item.color
      });
    }
  }

  return {
    count: result.length,
    data: result,
    processed: merged
  };
}
```
