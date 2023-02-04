import React from 'react'
import { createRoot } from 'react-dom/client';
import Select, { components } from "react-select";

const MultiValueLabel = props => {
  return (
    <components.MultiValueLabel
      {...props}
      innerProps={{
        ...props.innerProps,
        onClick: e => {
          e.stopPropagation(); // doesn't do anything, sadly
          e.preventDefault(); // doesn't do anything, sadly
          // still unsure how to preven the menu from opening
          // alert(props.data.label);
        }
      }}
    />
  );
};

SelectHook = {
  mounted(){
    const wrapper = this.el;
    const selectWrapper = wrapper.querySelector(".select-wrapper")
    const root = createRoot(selectWrapper);
    const selectElement = this.el.querySelector("select")
    const initialOptions = selectElement.options

    function handleChange(data){
      console.log(data)
      updateSelectOptions(data)
    }

    function convertOptionsToMap(){
      return Array.from(initialOptions).map(option => ({
        value: option.value,
        label: option.text,
        selected: option.selected
      }));
    }

    function getDefaultValues(){
      return convertOptionsToMap().filter((o)=> o.selected )
    }

    function updateSelectOptions(optionsJson) {
      let optionsArray = optionsJson
    
      // Remove existing options
      selectElement.innerHTML = "";
    
      // Add new options
      optionsArray.forEach(option => {
        let newOption = new Option(option.label, option.value, option.selected);
        newOption.selected = true //option.selected
        selectElement.add(newOption);
      });
    }

    root.render(
      <div phx-update={"ignore"} id="ssss">
        <Select
          //value={selectedOption}
          defaultValue={getDefaultValues()}
          components={{ MultiValueLabel }}
          options={convertOptionsToMap()}
          onChange={handleChange}
          closeMenuOnSelect={false}
          className="my-react-select-container"
          classNamePrefix="my-react-select"
          isMulti
        />
      </div>
    );
  },

  destroyed(){
   
  },
  reconnected(){ },
  updated(){ }
}

export default SelectHook