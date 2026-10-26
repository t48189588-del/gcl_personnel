This script are to be run inside Excel automation tab or be called by power automate `Run Script` action

[Office Script documentation](https://learn.microsoft.com/en-us/office/dev/scripts/)

Script:
- [Flattening working schedules](#flattening-working-schedules)
- [Table generation (for working reports templates)](#table-generation-for-working-reports-templates)
- [Filling working reports](#filling-working-reports)

## Flattening working schedules 
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
    date: string,
    startTime: string;
    endTime: string;
    value: string;
    location: string;
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

      const times = values[b][1].split("-");

      result.push({
        staff: header[a],
        date: currentDate,
        startTime: times[0],
        endTime: times[1],
        value: color ? "approved" : "available",
        location: values[b][a],
        color
      });
    }
  }
  const merged: {
    staff: string,
    date:string,
    startTime: string,
    endTime: string,
    color: string,
    value: string,
    location: string
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
        date:item.date,
        startTime:item.startTime,
        endTime:item.endTime,
        value:item.value,
        color:item.color,
        location:item.location
      });
    }
  }

  return {
    count: result.length,
    data: texts,
    processed: merged
  };
}
```

## Table generation (for working reports templates)
```
function main(workbook: ExcelScript.Workbook, reiwaYear: number, monthNumber: number) {
	let selectedSheet = workbook.getActiveWorksheet();
	selectedSheet.setName(`R8.${monthNumber}`);

	// Set Headers
	selectedSheet.getRange("C1").setValue("業務開始・終了時間記録簿　兼　時間外勤務等命令報告書");
	selectedSheet.getRange("A2").setValue("所　属：");
	selectedSheet.getRange("B2").setValue("教養教育院事務課");
	selectedSheet.getRange("F2").setValue("氏名：");
	selectedSheet.getRange("G2").setValue("student name");
	selectedSheet.getRange("A4").setFormulaLocal(`${reiwaYear+2018}/${monthNumber}/1`);
	selectedSheet.getRange("G4").setValue("※予め予定されている勤務日の【所定の勤務時間】欄に【勤務時間】をご記入ください。");
	selectedSheet.getRange("B5").setValue("曜日");
	// Merge range R5:R7 on selectedSheet
	selectedSheet.getRange("B5:B7").merge(false);
	selectedSheet.getRange("B5:B7").getFormat().setHorizontalAlignment(ExcelScript.HorizontalAlignment.center);

	selectedSheet.getRange("C5").setValue("所定の勤務時間");
	// Merge range R5:R7 on selectedSheet
	selectedSheet.getRange("C5:D5").merge(false);
	selectedSheet.getRange("C5:D5").getFormat().setHorizontalAlignment(ExcelScript.HorizontalAlignment.center);
	selectedSheet.getRange("E5").setValue("実勤務時間");
	// Merge range R5:R7 on selectedSheet
	selectedSheet.getRange("E5:G5").merge(false);
	selectedSheet.getRange("E5:G5").getFormat().setHorizontalAlignment(ExcelScript.HorizontalAlignment.center);

	selectedSheet.getRange("H5").setValue("時間外勤務（休憩時間を除く）");
	// Merge range R5:R7 on selectedSheet
	selectedSheet.getRange("H5:N5").merge(false);
	selectedSheet.getRange("H5:N5").getFormat().setHorizontalAlignment(ExcelScript.HorizontalAlignment.center);

	selectedSheet.getRange("C6").setValue("始業時刻");
	// Merge range R5:R7 on selectedSheet
	selectedSheet.getRange("C6:C7").merge(false);
	selectedSheet.getRange("C6:C7").getFormat().setHorizontalAlignment(ExcelScript.HorizontalAlignment.center);
	selectedSheet.getRange("D6").setValue("終業時刻");
	selectedSheet.getRange("D6:D7").merge(false);
	selectedSheet.getRange("D6:D7").getFormat().setHorizontalAlignment(ExcelScript.HorizontalAlignment.center);
	selectedSheet.getRange("E6").setValue("始業時刻");
	selectedSheet.getRange("E6:E7").merge(false);
	selectedSheet.getRange("E6:E7").getFormat().setHorizontalAlignment(ExcelScript.HorizontalAlignment.center);
	selectedSheet.getRange("F6").setValue("終業時刻");
	selectedSheet.getRange("F6:F7").merge(false);
	selectedSheet.getRange("F6:F7").getFormat().setHorizontalAlignment(ExcelScript.HorizontalAlignment.center);
	selectedSheet.getRange("G6").setValue("時間数有給含（※１）");
	selectedSheet.getRange("G6:G7").merge(false);
	selectedSheet.getRange("G6:G7").getFormat().setHorizontalAlignment(ExcelScript.HorizontalAlignment.center);
	selectedSheet.getRange("H6").setValue("100");
	selectedSheet.getRange("H7").setValue("100");
	selectedSheet.getRange("I6").setValue("125");
	selectedSheet.getRange("I7").setValue("100");
	selectedSheet.getRange("J6").setValue("25");
	selectedSheet.getRange("J7").setValue("100");

	selectedSheet.getRange("K6").setValue("事由");
	selectedSheet.getRange("K6:K7").merge(false);
	selectedSheet.getRange("K6:K7").getFormat().setHorizontalAlignment(ExcelScript.HorizontalAlignment.center);

	selectedSheet.getRange("L6").setValue("業務内容");
	selectedSheet.getRange("L6:L7").merge(false);
	selectedSheet.getRange("L6:L7").getFormat().setHorizontalAlignment(ExcelScript.HorizontalAlignment.center);

	selectedSheet.getRange("M6").setValue("本人印");
	selectedSheet.getRange("M6:M7").merge(false);
	selectedSheet.getRange("M6:M7").getFormat().setHorizontalAlignment(ExcelScript.HorizontalAlignment.center);

	selectedSheet.getRange("N6").setValue("命令者印");
	selectedSheet.getRange("N6:N7").merge(false);
	selectedSheet.getRange("N6:N7").getFormat().setHorizontalAlignment(ExcelScript.HorizontalAlignment.center);

	selectedSheet.getRange("O6").setValue("備考（※２）");
	selectedSheet.getRange("O6:O7").merge(false);
	selectedSheet.getRange("O6:O7").getFormat().setHorizontalAlignment(ExcelScript.HorizontalAlignment.center);

	// Set range Q8:Q9 on selectedSheet
	selectedSheet.getRange("A8:A9").setFormulasLocal([["=A4"],["=A8+1"]]);
	// Auto fill range
	selectedSheet.getRange("A9").autoFill("A9:A37", ExcelScript.AutoFillType.fillCopy);
	
	// Set range Q8:Q9 on selectedSheet
	selectedSheet.getRange("B8").setFormulasLocal([["=A8"]]);
	// Auto fill range
	selectedSheet.getRange("B8").autoFill("B8:B37", ExcelScript.AutoFillType.fillCopy);

	// Set range Q39 on selectedSheet
	selectedSheet.getRange("F39").setValue("会計時間");
	// Set range W39 on selectedSheet
	selectedSheet.getRange("G39").setFormulaLocal("=SUM(G8:G38)");
	selectedSheet.getRange("H39").setFormulaLocal("=SUM(H8:H38)");
	selectedSheet.getRange("I39").setFormulaLocal("=SUM(I8:I38)");
	selectedSheet.getRange("J39").setFormulaLocal("=SUM(J8:J38)");

	
	// Set border for range A5:O38 on selectedSheet
	selectedSheet.getRange("A5:O38").getFormat().getRangeBorder(ExcelScript.BorderIndex.insideHorizontal).setStyle(ExcelScript.BorderLineStyle.continuous);
	selectedSheet.getRange("A5:O38").getFormat().getRangeBorder(ExcelScript.BorderIndex.insideHorizontal).setColor("000000");
	selectedSheet.getRange("A5:O38").getFormat().getRangeBorder(ExcelScript.BorderIndex.insideHorizontal).setWeight(ExcelScript.BorderWeight.thin);
	selectedSheet.getRange("A5:O38").getFormat().getRangeBorder(ExcelScript.BorderIndex.insideVertical).setStyle(ExcelScript.BorderLineStyle.continuous);
	selectedSheet.getRange("A5:O38").getFormat().getRangeBorder(ExcelScript.BorderIndex.insideVertical).setColor("000000");
	selectedSheet.getRange("A5:O38").getFormat().getRangeBorder(ExcelScript.BorderIndex.insideVertical).setWeight(ExcelScript.BorderWeight.thin);
	selectedSheet.getRange("A5:O38").getFormat().getRangeBorder(ExcelScript.BorderIndex.edgeBottom).setStyle(ExcelScript.BorderLineStyle.continuous);
	selectedSheet.getRange("A5:O38").getFormat().getRangeBorder(ExcelScript.BorderIndex.edgeBottom).setColor("000000");
	selectedSheet.getRange("A5:O38").getFormat().getRangeBorder(ExcelScript.BorderIndex.edgeBottom).setWeight(ExcelScript.BorderWeight.thin);
	selectedSheet.getRange("A5:O38").getFormat().getRangeBorder(ExcelScript.BorderIndex.edgeTop).setStyle(ExcelScript.BorderLineStyle.continuous);
	selectedSheet.getRange("A5:O38").getFormat().getRangeBorder(ExcelScript.BorderIndex.edgeTop).setColor("000000");
	selectedSheet.getRange("A5:O38").getFormat().getRangeBorder(ExcelScript.BorderIndex.edgeTop).setWeight(ExcelScript.BorderWeight.thin);
	selectedSheet.getRange("A5:O38").getFormat().getRangeBorder(ExcelScript.BorderIndex.edgeLeft).setStyle(ExcelScript.BorderLineStyle.continuous);
	selectedSheet.getRange("A5:O38").getFormat().getRangeBorder(ExcelScript.BorderIndex.edgeLeft).setColor("000000");
	selectedSheet.getRange("A5:O38").getFormat().getRangeBorder(ExcelScript.BorderIndex.edgeLeft).setWeight(ExcelScript.BorderWeight.thin);
	selectedSheet.getRange("A5:O38").getFormat().getRangeBorder(ExcelScript.BorderIndex.edgeRight).setStyle(ExcelScript.BorderLineStyle.continuous);
	selectedSheet.getRange("A5:O38").getFormat().getRangeBorder(ExcelScript.BorderIndex.edgeRight).setColor("000000");
	selectedSheet.getRange("A5:O38").getFormat().getRangeBorder(ExcelScript.BorderIndex.edgeRight).setWeight(ExcelScript.BorderWeight.thin);

	let conditionalFormatting: ExcelScript.ConditionalFormat;
	// Create custom from range A9:O39 on selectedSheet
	conditionalFormatting = selectedSheet.getRange("A9:O38").addConditionalFormat(ExcelScript.ConditionalFormatType.custom);
	conditionalFormatting.getCustom().getFormat().getFont().setColor("#001600");
	conditionalFormatting.getCustom().getFormat().getFill().setColor("#ff9797");
	conditionalFormatting.getCustom().getRule().setFormula("=Weekday($A9,2)=6");

	// Create custom from range A9:O39 on selectedSheet
	conditionalFormatting = selectedSheet.getRange("A9:O38").addConditionalFormat(ExcelScript.ConditionalFormatType.custom);
	conditionalFormatting.getCustom().getFormat().getFont().setColor("#001600");
	conditionalFormatting.getCustom().getFormat().getFill().setColor("#d9d9d9");
	conditionalFormatting.getCustom().getRule().setFormula("=Weekday($A9,2)=7");

	
	// Set format for extended range obtained by extending down from range B8 on selectedSheet
	selectedSheet.getRange("B8").getExtendedRange(ExcelScript.KeyboardDirection.down).setNumberFormatLocal("aaa");

	selectedSheet.getRange("B42").setValue("命令者：");
	selectedSheet.getRange("D42").setValue("山中　剛");
	selectedSheet.getRange("G44").setFormulaLocal("=COUNTA(G8:G37)");

	selectedSheet.getRange("I44").setValue("勤務");
	selectedSheet.getRange("I45").setValue("時間数");
	selectedSheet.getRange("J44").setFormulaLocal("=G39");
	selectedSheet.getRange("J44:J45").merge(false);
	selectedSheet.getRange("J44:J45").getFormat().setHorizontalAlignment(ExcelScript.HorizontalAlignment.center);

	selectedSheet.getRange("K44").setValue("100");
	selectedSheet.getRange("K45").setValue("100");
	selectedSheet.getRange("L44").setFormulaLocal("=H39");
	selectedSheet.getRange("L44:L45").merge(false);
	selectedSheet.getRange("L44:L45").getFormat().setHorizontalAlignment(ExcelScript.HorizontalAlignment.center);

	selectedSheet.getRange("M44").setValue("125");
	selectedSheet.getRange("M45").setValue("100");
	selectedSheet.getRange("N44").setFormulaLocal("=I39");
	selectedSheet.getRange("N44:N45").merge(false);
	selectedSheet.getRange("N44:N45").getFormat().setHorizontalAlignment(ExcelScript.HorizontalAlignment.center);

	selectedSheet.getRange("O44").setValue("25");
	selectedSheet.getRange("O45").setValue("100");
	selectedSheet.getRange("P44").setFormulaLocal("=J39");
	selectedSheet.getRange("P44:P45").merge(false);
	selectedSheet.getRange("P44:P45").getFormat().setHorizontalAlignment(ExcelScript.HorizontalAlignment.center);

	selectedSheet.getRange("A4").setNumberFormatLocal("yyyy年-mm月");
	selectedSheet.getRange("A8:A38").setNumberFormatLocal("[$-ja-JP]d\"日\"");
}
```

## Filling working reports 
```
interface ScheduleItem {
  date?: string;
  scheduledStart?: string;
  scheduledEnd?: string;
  actualStart?: string;
  actualEnd?: string;
  calculated?: string | number;
  description?: string;
}

function main(
  workbook: ExcelScript.Workbook,
  inputJson: string,
  reiwaYear: number,
  monthNumber: number) {

  // Parse the incoming JSON array payload
  const items: ScheduleItem[] = typeof inputJson === "string" ? JSON.parse(inputJson) : JSON.parse(JSON.stringify(inputJson));

  const sheetName = `R${reiwaYear}.${monthNumber}`;
  const sheet = workbook.getWorksheet(sheetName);
  if (!sheet) {
    console.log(`Sheet "${sheetName}" was not found.`);
    return;
  }
  sheet.getRange("S2").setValue(inputJson);

  // Read day numbers from column A (rows 8 through 38)
  const dayRange = sheet.getRange("A8:A38");
  sheet.getRange("C8:O38").setValue("");
  const dayValues: string[][] = dayRange.getTexts();

  // Helper function to extract "HH:mm" from ISO time strings
  const extractTime = (isoString?: string): string => {
    if (!isoString) return "";
    const parts: string[] = isoString.split("T");
    if (parts.length < 2) return "";
    return parts[1].substring(0, 5);
  };

  // Helper function to safely read cell text (prevents Excel from returning time decimals)
  const getCellText = (range: ExcelScript.Range): string => {
    const texts = range.getTexts();
    return (texts && texts[0] && texts[0][0]) ? String(texts[0][0]).trim() : "";
  };

  // Helper function to safely append values with a line break
  const appendWithNewline = (existingValue: string, newValue: string): string => {
    if (!existingValue) return newValue;
    if (!newValue) return existingValue;
    return existingValue + "\n" + newValue;
  };

  // Loop through each item in the parsed array
  for (let item of items) {
    if (!item.date) continue;
    const targetDay = new Date(item.date).getDate();
    let targetRowIndex = -1;

    for (let i = 0; i < dayValues.length; i++) {
      const cellValue = String(dayValues[i][0] || "").trim();
      const cellDayNum = parseInt(cellValue, 10);
      if (cellDayNum === targetDay) {
        targetRowIndex = 8 + i;
        break;
      }
    }

    // Write or append values into the matched row if found
    if (targetRowIndex !== -1) {
      const rowCellC = sheet.getRange(`C${targetRowIndex}`);
      const rowCellD = sheet.getRange(`D${targetRowIndex}`);
      const rowCellE = sheet.getRange(`E${targetRowIndex}`);
      const rowCellF = sheet.getRange(`F${targetRowIndex}`);
      const rowCellG = sheet.getRange(`G${targetRowIndex}`);
      const rowCellL = sheet.getRange(`L${targetRowIndex}`);

      // Ensure time columns are treated as Text so Excel doesn't convert them to decimals
      rowCellC.setNumberFormat("@");
      rowCellD.setNumberFormat("@");
      rowCellE.setNumberFormat("@");
      rowCellF.setNumberFormat("@");

      // Update times with line breaks using text retrieval
      rowCellC.setValue(appendWithNewline(getCellText(rowCellC), extractTime(item.scheduledStart)));
      rowCellD.setValue(appendWithNewline(getCellText(rowCellD), extractTime(item.scheduledEnd)));
      rowCellE.setValue(appendWithNewline(getCellText(rowCellE), extractTime(item.actualStart)));
      rowCellF.setValue(appendWithNewline(getCellText(rowCellF), extractTime(item.actualEnd)));

      // Sum up the calculated hours
      const currentTotalHours = Number(rowCellG.getValue()) || 0;
      const itemCalculated = Number(item.calculated) || 0;
      rowCellG.setValue(currentTotalHours + itemCalculated);

      // Update description with line break
      rowCellL.setValue(appendWithNewline(getCellText(rowCellL), item.description || ""));
    }
  }
  sheet.getRange("G8:G39").setNumberFormatLocal("#,##0.00");
}
```