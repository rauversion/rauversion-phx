import flatpickr from "flatpickr";

export const datetimeHook = { 
  mounted() {
    flatpickr(this.el, {
      altInput: true,
      altFormat: "D F d, Y. h:i K", //"Y-m-d h:i K",
      dateFormat: "Z",
      enableTime: true,
      parseDate(dateString, format) {
        var wrongDate = new Date(dateString);
        return wrongDate
        //var localizedDate = new Date(wrongDate.getTime() - wrongDate.getTimezoneOffset() * 60000);
        //return dateString;
      },
    });
  }
}