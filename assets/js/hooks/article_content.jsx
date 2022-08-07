import React from 'react';
import { render } from 'react-dom';
import Dante, {
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

ArticleContent = {
  mounted(){
    const wrapper = this.el;

    render(
      <Dante 
        readOnly={true}
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
          EmbedBlockConfig(),
          VideoBlockConfig(),
          GiphyBlockConfig(),
          VideoRecorderBlockConfig(),
          SpeechToTextBlockConfig(),
        ]}
      />,
      wrapper
    );

  },
  destroyed(){
   
  },
  reconnected(){ },
  updated(){ }
}

export default ArticleContent