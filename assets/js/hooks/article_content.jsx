import React from 'react';

import { createRoot } from 'react-dom/client';

import Dante, {
  darkTheme,
  defaultTheme,
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
    const root = createRoot(wrapper);

    root.render(
      <Dante 
        readOnly={true}
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
          EmbedBlockConfig(),
          VideoBlockConfig(),
          GiphyBlockConfig(),
          VideoRecorderBlockConfig(),
          SpeechToTextBlockConfig(),
        ]}
      />
    );

  },
  destroyed(){
   
  },
  reconnected(){ },
  updated(){ }
}

export default ArticleContent