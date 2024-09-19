import { ShowToastEvent } from "lightning/platformShowToastEvent";

const showToast = (title, message, variant) => {
  const event = new ShowToastEvent({
    title: title,
    message: message,
    variant: variant
  });
  return event;
};

export { showToast };
