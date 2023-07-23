import React, {useState} from 'react';
import { createRoot } from 'react-dom/client';
import { DirectUpload } from "@rails/activestorage"

AudioUploader = {
  mounted(){
    const wrapper = this.el.querySelector(".uploader");

    const root = createRoot(wrapper);

    let App = () => {
      const [progress, setProgress] = useState(0);
      const [audioSrc, setAudioSrc] = useState(null);
      const [selectedFile, setSelectedFile] = useState(null);



      React.useEffect(() => {
        const progressHandler = (event) => {
          setProgress(event.detail);
        };

        wrapper.addEventListener("uploadProgress", progressHandler);
        
        return () => {
          wrapper.removeEventListener("uploadProgress", progressHandler);
        };
      }, []);

      const handleSubmit = (e) => {
        e.preventDefault();
        //const formData = new FormData(e.target);
        const file = selectedFile // formData.get('fileUpload');
        console.log(file);
        this.upload(file, (a) => {
          console.log("AUDIO UPLOADED")
          this.pushEvent('audio_uploaded', { contents: a });
        });
        setProgress(0); // Reset progress on new upload
      };

      const handleFileChange = (e) => {
        const file = e.target.files[0];
        setSelectedFile(file);
        console.log(file)

        setAudioSrc(URL.createObjectURL(file));
      }

      function percentage(){
        return Number((progress).toFixed(1))
      }

      const handleFileDrop = (e) => {
        e.preventDefault();
        const file = e.dataTransfer.files[0];
        console.log(file)
        setSelectedFile(file);
        setAudioSrc(URL.createObjectURL(file));
      };

      const handleDragOver = (e) => {
        e.preventDefault(); // Required to allow drop event
      };

      {/*<form 
          action="/submit_form" 
          method="post" 
          encType="multipart/form-data"
          onSubmit={handleSubmit}>
          <label htmlFor="fileUpload">Upload a File:</label>
          <input type="file" id="fileUpload" name="fileUpload"/>
          <input type="submit" value="Submit"/>
          <p>Upload Progress: {percentage()}%</p>
        </form>
      */}

      return (
        <div className="flex-col">
          <div className="text-center">
            <h3 className="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100">
              Drag and drop your tracks &amp; albums here 
            </h3>
            <p className="mt-1 max-w-2xl text-sm text-gray-500"> 
              Provide FLAC, WAV, ALAC, or AIFF for highest audio quality. 
            </p>
          </div>
          <form 
          action="/submit_form" 
          method="post" 
          encType="multipart/form-data"
          onSubmit={handleSubmit}>
          
            <div className="mt-6 sm:mt-5 space-y-6 sm:space-y-5"
              onDrop={handleFileDrop} 
              onDragOver={handleDragOver}>
              <div className="flex-col">
                <div className="mt-1 sm:mt-0 sm:col-span-2">
                  <div className="max-w-lg flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 dark:border-gray-700 border-dashed rounded-md">
                    <div className="space-y-1 text-center">
                      <svg xmlns="http://www.w3.org/2000/svg" className="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth="2">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3"></path>
                      </svg>
                      <div className="flex flex-col space-y-2 text-sm text-gray-600 py-3">
                        {/*<label className="relative cursor-pointer rounded-md font-medium text-brand-600 hover:text-brand-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-brand-500">
                          <span>Upload a Audio file</span>
                          <input id="phx-F3MQNT6LavJO5AgD" type="file" name="audio" accept=".mp3,.mp4,.wav,.ogg,.flac,.aiff" data-phx-hook="Phoenix.LiveFileUpload" data-phx-update="ignore" data-phx-upload-ref="phx-F3MQNT6LavJO5AgD" data-phx-active-refs="" data-phx-done-refs="" data-phx-preflighted-refs="" className="hidden">
                          </label>*/}

                        <div className="flex justify-center">
                          <label htmlFor="fileUpload" 
                            className="relative cursor-pointer rounded-md font-medium text-brand-600 hover:text-brand-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-brand-500">
                            <span>Upload a Audio file</span>
                            <input 
                              type="file"
                              className='hidden'
                              id="fileUpload" 
                              name="fileUpload"
                              onChange={handleFileChange}
                              accept=".mp3,.mp4,.wav,.ogg,.flac,.aiff"
                            />
                            
                          </label>
                          <p className="pl-1">or drag and drop</p>
                        </div>

                        {audioSrc && 
                          <audio controls src={audioSrc}>
                          Your browser does not support the audio element.
                          </audio>
                        }
                        
                      </div>
                      <div>
                        {
                          progress > 0 &&
                          `${percentage()}%`
                        }
                      </div>
                      <p className="text-xs text-gray-500"> Audio, up to 200MB </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            { selectedFile &&
              <div className="flex items-center justify-end my-2">
                <a href="/michelson" className="bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" 
                  data-phx-link="redirect" 
                  data-phx-link-state="push">
                  Cancel
                </a>
                <button 
                  className="ml-3 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" 
                  phx-disable-with="Guardando..."
                  type="submit">
                  Continuar
                </button>
              </div>
            }

          </form>

        </div>
      );
    };

    root.render(<App />);
  },

  handleSubmit(e, ctx){
    e.preventDefault()
    const formData = new FormData(e.target)
    var file = formData.get('fileUpload')
    console.log(file)
    ctx.upload(file, (a)=>{
      this.pushEvent('audio_uploaded', { contents: a });
    })

  },

  upload(file, cb){
    if(!file) return
    // your form needs the file_field direct_upload: true, which
    // provides data-direct-upload-url
    const url = '/active_storage/direct_uploads'
    const upload = new DirectUpload(file, url, this)
  
    upload.create((error, blob) => {
      if (error) {
        // Handle the error
      } else {
        cb(blob)
      }
    })
  },

  directUploadWillStoreFileWithXHR(xhr) {
    //this.dispatch("before-storage-request", { xhr })
    xhr.upload.addEventListener("progress", 
      event => this.uploadRequestDidProgress(event)
    )
  },

  uploadRequestDidProgress(event){
    const {loaded, total} = event
    let progress = (loaded / total) * 100;

    // Dispatch custom event
    const ev = new CustomEvent("uploadProgress", { detail: progress });
    this.el.dispatchEvent(ev);

  },

  destroyed(){
   
  },
  reconnected(){ },
  updated(){ }
}

export default AudioUploader