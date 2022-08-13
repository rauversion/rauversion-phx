import React from 'react';
import { render } from 'react-dom';
import Dante, {
  defaultTheme, 
  darkTheme,
  ImageBlockConfig,
  CodeBlockConfig,
  DividerBlockConfig,
  PlaceholderBlockConfig,
  EmbedBlockConfig,
  VideoBlockConfig,
  GiphyBlockConfig,
  VideoRecorderBlockConfig,
  SpeechToTextBlockConfig,
} from 'dante3'
import { DirectUpload } from "@rails/activestorage"

Editor = {
  mounted(){
    const wrapper = this.el;
    
    render(
      <Dante 
        theme={darkTheme}
        content={JSON.parse(wrapper.dataset.field)}
        widgets={[
          ImageBlockConfig({
            options: {
              upload_handler: (file, ctx) => {
                console.log("UPLOADED FILE!!!!", file)
                
                this.upload(file, (blob)=>{
                  console.log(blob)
                  console.log(ctx)
                  ctx.updateAttributes({
                    url: blob.service_url
                  })
                })
              }
            }
          }),
          CodeBlockConfig(),
          DividerBlockConfig(),
          PlaceholderBlockConfig(),
          EmbedBlockConfig({
            options: {
              endpoint: "/oembed?url=",
              placeholder: "Paste a link to embed content from another site (e.g. Twitter) and press Enter"
            },
          }),
          VideoBlockConfig(),
          GiphyBlockConfig(),
          VideoRecorderBlockConfig({
            options: {
              upload_handler: (file, ctx) => {
                console.log("UPLOADED VIDEO FILE!!!!", file)
                
                this.upload(file, (blob)=>{
                  console.log(blob)
                  console.log(ctx)
                  ctx.updateAttributes({
                    url: blob.service_url
                  })
                })
              }
            }
          }),
          SpeechToTextBlockConfig(),
        ]}
        onUpdate={(editor)=>{
          //console.log(editor.getHTML())
          //wrapper.dataset.field = editor.getHTML()

          this.pushEvent("update-content", {content: editor.getJSON() } )
      }}/>,
      wrapper
    );

  },

  upload(file, cb){
    if(!file) return
    // your form needs the file_field direct_upload: true, which
    // provides data-direct-upload-url
    const url = '/active_storage/direct_uploads'
    const upload = new DirectUpload(file, url)
  
    upload.create((error, blob) => {
      if (error) {
        // Handle the error
      } else {
        cb(blob)
      }
    })
  },

  destroyed(){
   
  },
  reconnected(){ },
  updated(){ }
}

export default Editor