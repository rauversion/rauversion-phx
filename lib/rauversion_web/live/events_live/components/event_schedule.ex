defmodule RauversionWeb.EventsLive.EventSchedule do
  use RauversionWeb, :live_component

  def render(assigns) do
    ~H"""

    <section aria-label="Schedule" class="py-20 sm:py-32">
      <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 relative z-10">
        <div class="mx-auto max-w-2xl lg:mx-0 lg:max-w-4xl lg:pr-24">
          <h2 class="font-display text-4xl font-medium tracking-tighter text-brand-600 sm:text-5xl">Our three day schedule is jam-packed with brilliant, creative, evil geniuses.</h2>
          <p class="mt-4 font-display text-2xl tracking-tight text-brand-100">The worst people in our industry giving the best talks you’ve ever seen. Nothing will be recorded and every attendee has to sign an NDA to watch the talks.</p>
        </div>
      </div>
      <div class="relative mt-14 sm:mt-24">
        <div class="absolute inset-x-0 -top-40 -bottom-32 overflow-hidden bg-gray-900">
          <img alt="" src="/_next/static/media/background.6c3571e0.jpg" width="918" height="1495" decoding="async" data-nimg="future" class="absolute left-full top-0 -translate-x-1/2 sm:left-1/2 sm:translate-y-[-15%] sm:translate-x-[-20%] md:translate-x-0 lg:translate-x-[5%] lg:translate-y-[4%] xl:translate-y-[-8%] xl:translate-x-[27%]" loading="lazy">
          <div class="absolute inset-x-0 top-0 h-40 bg-gradient-to-b from-black"></div>
          <div class="absolute inset-x-0 bottom-0 h-40 bg-gradient-to-t from-black"></div>
        </div>
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 relative">
          <div class="mx-auto grid max-w-2xl grid-cols-1 gap-y-6 sm:grid-cols-2 lg:hidden">
            <div class="-mx-4 flex gap-x-4 gap-y-10 overflow-x-auto pl-4 pb-4 sm:mx-0 sm:flex-col sm:pb-0 sm:pl-0 sm:pr-8" role="tablist" aria-orientation="vertical">
              <div class="relative w-3/4 flex-none pr-4 sm:w-auto sm:pr-0">
                <h3 class="text-2xl font-semibold tracking-tight text-brand-900">
                  <time datetime="2022-04-04">
                    <button class="[&amp;:not(:focus-visible)]:focus:outline-none" id="headlessui-tabs-tab-:R5cqdm:" role="tab" type="button" aria-selected="true" tabindex="0" aria-controls="headlessui-tabs-panel-:R1kqdm:">
                      <span class="absolute inset-0"></span>April 4 </button>
                  </time>
                </h3>
                <p class="mt-1.5 text-base tracking-tight text-brand-900">The first day of the conference is focused on dark patterns for ecommerce.</p>
              </div>
              <div class="relative w-3/4 flex-none pr-4 sm:w-auto sm:pr-0 opacity-70">
                <h3 class="text-2xl font-semibold tracking-tight text-brand-900">
                  <time datetime="2022-04-05">
                    <button class="[&amp;:not(:focus-visible)]:focus:outline-none" id="headlessui-tabs-tab-:R6cqdm:" role="tab" type="button" aria-selected="false" tabindex="-1">
                      <span class="absolute inset-0"></span>April 5 </button>
                  </time>
                </h3>
                <p class="mt-1.5 text-base tracking-tight text-brand-900">Next we spend the day talking about deceiving people with technology.</p>
              </div>
              <div class="relative w-3/4 flex-none pr-4 sm:w-auto sm:pr-0 opacity-70">
                <h3 class="text-2xl font-semibold tracking-tight text-brand-900">
                  <time datetime="2022-04-06">
                    <button class="[&amp;:not(:focus-visible)]:focus:outline-none" id="headlessui-tabs-tab-:R7cqdm:" role="tab" type="button" aria-selected="false" tabindex="-1">
                      <span class="absolute inset-0"></span>April 6 </button>
                  </time>
                </h3>
                <p class="mt-1.5 text-base tracking-tight text-brand-900">We close out the event previewing new techniques that are still in development.</p>
              </div>
            </div>
            <div>
              <div class="[&amp;:not(:focus-visible)]:focus:outline-none" id="headlessui-tabs-panel-:R1kqdm:" role="tabpanel" tabindex="0" aria-labelledby="headlessui-tabs-tab-:R5cqdm:">
                <ol role="list" class="space-y-8 bg-white/60 py-14 px-10 text-center shadow-xl shadow-brand-900/5 backdrop-blur">
                  <li aria-label="Steven McHail talking about Not so one-time payments at 9:00AM - 10:00AM PST">
                    <h4 class="text-lg font-semibold tracking-tight text-brand-900">Steven McHail</h4>
                    <p class="mt-1 tracking-tight text-brand-900">Not so one-time payments</p>
                    <p class="mt-1 font-mono text-sm text-slate-500">
                      <time datetime="2022-04-04T9:00AM-08:00">9:00AM</time>
                      <!-- -->-
                      <!-- -->
                      <time datetime="2022-04-04T10:00AM-08:00">10:00AM</time>
                      <!-- -->PST
                    </p>
                  </li>
                  <li aria-label="Jaquelin Isch talking about The finer print at 10:00AM - 11:00AM PST">
                    <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                    <h4 class="text-lg font-semibold tracking-tight text-brand-900">Jaquelin Isch</h4>
                    <p class="mt-1 tracking-tight text-brand-900">The finer print</p>
                    <p class="mt-1 font-mono text-sm text-slate-500">
                      <time datetime="2022-04-04T10:00AM-08:00">10:00AM</time>
                      <!-- -->-
                      <!-- -->
                      <time datetime="2022-04-04T11:00AM-08:00">11:00AM</time>
                      <!-- -->PST
                    </p>
                  </li>
                  <li aria-label="Dianne Guilianelli talking about Post-purchase blackmail at 11:00AM - 12:00PM PST">
                    <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                    <h4 class="text-lg font-semibold tracking-tight text-brand-900">Dianne Guilianelli</h4>
                    <p class="mt-1 tracking-tight text-brand-900">Post-purchase blackmail</p>
                    <p class="mt-1 font-mono text-sm text-slate-500">
                      <time datetime="2022-04-04T11:00AM-08:00">11:00AM</time>
                      <!-- -->-
                      <!-- -->
                      <time datetime="2022-04-04T12:00PM-08:00">12:00PM</time>
                      <!-- -->PST
                    </p>
                  </li>
                  <li aria-label="Lunch talking about null at 12:00PM - 1:00PM PST">
                    <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                    <h4 class="text-lg font-semibold tracking-tight text-brand-900">Lunch</h4>
                    <p class="mt-1 font-mono text-sm text-slate-500">
                      <time datetime="2022-04-04T12:00PM-08:00">12:00PM</time>
                      <!-- -->-
                      <!-- -->
                      <time datetime="2022-04-04T1:00PM-08:00">1:00PM</time>
                      <!-- -->PST
                    </p>
                  </li>
                  <li aria-label="Ronni Cantadore talking about Buy or die at 1:00PM - 2:00PM PST">
                    <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                    <h4 class="text-lg font-semibold tracking-tight text-brand-900">Ronni Cantadore</h4>
                    <p class="mt-1 tracking-tight text-brand-900">Buy or die</p>
                    <p class="mt-1 font-mono text-sm text-slate-500">
                      <time datetime="2022-04-04T1:00PM-08:00">1:00PM</time>
                      <!-- -->-
                      <!-- -->
                      <time datetime="2022-04-04T2:00PM-08:00">2:00PM</time>
                      <!-- -->PST
                    </p>
                  </li>
                  <li aria-label="Erhart Cockrin talking about In-person cancellation at 2:00PM - 3:00PM PST">
                    <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                    <h4 class="text-lg font-semibold tracking-tight text-brand-900">Erhart Cockrin</h4>
                    <p class="mt-1 tracking-tight text-brand-900">In-person cancellation</p>
                    <p class="mt-1 font-mono text-sm text-slate-500">
                      <time datetime="2022-04-04T2:00PM-08:00">2:00PM</time>
                      <!-- -->-
                      <!-- -->
                      <time datetime="2022-04-04T3:00PM-08:00">3:00PM</time>
                      <!-- -->PST
                    </p>
                  </li>
                  <li aria-label="Parker Johnson talking about The pay/cancel switcheroo at 3:00PM - 4:00PM PST">
                    <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                    <h4 class="text-lg font-semibold tracking-tight text-brand-900">Parker Johnson</h4>
                    <p class="mt-1 tracking-tight text-brand-900">The pay/cancel switcheroo</p>
                    <p class="mt-1 font-mono text-sm text-slate-500">
                      <time datetime="2022-04-04T3:00PM-08:00">3:00PM</time>
                      <!-- -->-
                      <!-- -->
                      <time datetime="2022-04-04T4:00PM-08:00">4:00PM</time>
                      <!-- -->PST
                    </p>
                  </li>
                </ol>
              </div>
            </div>
          </div>
          <div class="hidden lg:grid lg:grid-cols-3 lg:gap-x-8">
            <section>
              <h3 class="text-2xl font-semibold tracking-tight text-brand-900">
                <time datetime="2022-04-04">April 4</time>
              </h3>
              <p class="mt-1.5 text-base tracking-tight text-brand-900">The first day of the conference is focused on dark patterns for ecommerce.</p>
              <ol role="list" class="mt-10 space-y-8 bg-white/60 py-14 px-10 text-center shadow-xl shadow-brand-900/5 backdrop-blur">
                <li aria-label="Steven McHail talking about Not so one-time payments at 9:00AM - 10:00AM PST">
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Steven McHail</h4>
                  <p class="mt-1 tracking-tight text-brand-900">Not so one-time payments</p>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-04T9:00AM-08:00">9:00AM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-04T10:00AM-08:00">10:00AM</time>
                    <!-- -->PST
                  </p>
                </li>
                <li aria-label="Jaquelin Isch talking about The finer print at 10:00AM - 11:00AM PST">
                  <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Jaquelin Isch</h4>
                  <p class="mt-1 tracking-tight text-brand-900">The finer print</p>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-04T10:00AM-08:00">10:00AM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-04T11:00AM-08:00">11:00AM</time>
                    <!-- -->PST
                  </p>
                </li>
                <li aria-label="Dianne Guilianelli talking about Post-purchase blackmail at 11:00AM - 12:00PM PST">
                  <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Dianne Guilianelli</h4>
                  <p class="mt-1 tracking-tight text-brand-900">Post-purchase blackmail</p>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-04T11:00AM-08:00">11:00AM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-04T12:00PM-08:00">12:00PM</time>
                    <!-- -->PST
                  </p>
                </li>
                <li aria-label="Lunch talking about null at 12:00PM - 1:00PM PST">
                  <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Lunch</h4>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-04T12:00PM-08:00">12:00PM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-04T1:00PM-08:00">1:00PM</time>
                    <!-- -->PST
                  </p>
                </li>
                <li aria-label="Ronni Cantadore talking about Buy or die at 1:00PM - 2:00PM PST">
                  <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Ronni Cantadore</h4>
                  <p class="mt-1 tracking-tight text-brand-900">Buy or die</p>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-04T1:00PM-08:00">1:00PM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-04T2:00PM-08:00">2:00PM</time>
                    <!-- -->PST
                  </p>
                </li>
                <li aria-label="Erhart Cockrin talking about In-person cancellation at 2:00PM - 3:00PM PST">
                  <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Erhart Cockrin</h4>
                  <p class="mt-1 tracking-tight text-brand-900">In-person cancellation</p>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-04T2:00PM-08:00">2:00PM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-04T3:00PM-08:00">3:00PM</time>
                    <!-- -->PST
                  </p>
                </li>
                <li aria-label="Parker Johnson talking about The pay/cancel switcheroo at 3:00PM - 4:00PM PST">
                  <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Parker Johnson</h4>
                  <p class="mt-1 tracking-tight text-brand-900">The pay/cancel switcheroo</p>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-04T3:00PM-08:00">3:00PM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-04T4:00PM-08:00">4:00PM</time>
                    <!-- -->PST
                  </p>
                </li>
              </ol>
            </section>
            <section>
              <h3 class="text-2xl font-semibold tracking-tight text-brand-900">
                <time datetime="2022-04-05">April 5</time>
              </h3>
              <p class="mt-1.5 text-base tracking-tight text-brand-900">Next we spend the day talking about deceiving people with technology.</p>
              <ol role="list" class="mt-10 space-y-8 bg-white/60 py-14 px-10 text-center shadow-xl shadow-brand-900/5 backdrop-blur">
                <li aria-label="Damaris Kimura talking about The invisible card reader at 9:00AM - 10:00AM PST">
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Damaris Kimura</h4>
                  <p class="mt-1 tracking-tight text-brand-900">The invisible card reader</p>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-05T9:00AM-08:00">9:00AM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-05T10:00AM-08:00">10:00AM</time>
                    <!-- -->PST
                  </p>
                </li>
                <li aria-label="Ibrahim Frasch talking about Stealing fingerprints at 10:00AM - 11:00AM PST">
                  <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Ibrahim Frasch</h4>
                  <p class="mt-1 tracking-tight text-brand-900">Stealing fingerprints</p>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-05T10:00AM-08:00">10:00AM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-05T11:00AM-08:00">11:00AM</time>
                    <!-- -->PST
                  </p>
                </li>
                <li aria-label="Cathlene Burrage talking about Voting machines at 11:00AM - 12:00PM PST">
                  <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Cathlene Burrage</h4>
                  <p class="mt-1 tracking-tight text-brand-900">Voting machines</p>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-05T11:00AM-08:00">11:00AM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-05T12:00PM-08:00">12:00PM</time>
                    <!-- -->PST
                  </p>
                </li>
                <li aria-label="Lunch talking about null at 12:00PM - 1:00PM PST">
                  <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Lunch</h4>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-05T12:00PM-08:00">12:00PM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-05T1:00PM-08:00">1:00PM</time>
                    <!-- -->PST
                  </p>
                </li>
                <li aria-label="Rinaldo Beynon talking about Blackhat SEO that works at 1:00PM - 2:00PM PST">
                  <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Rinaldo Beynon</h4>
                  <p class="mt-1 tracking-tight text-brand-900">Blackhat SEO that works</p>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-05T1:00PM-08:00">1:00PM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-05T2:00PM-08:00">2:00PM</time>
                    <!-- -->PST
                  </p>
                </li>
                <li aria-label="Waylon Hyden talking about Turning your audience into a botnet at 2:00PM - 3:00PM PST">
                  <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Waylon Hyden</h4>
                  <p class="mt-1 tracking-tight text-brand-900">Turning your audience into a botnet</p>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-05T2:00PM-08:00">2:00PM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-05T3:00PM-08:00">3:00PM</time>
                    <!-- -->PST
                  </p>
                </li>
                <li aria-label="Giordano Sagucio talking about Fly phishing at 3:00PM - 4:00PM PST">
                  <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Giordano Sagucio</h4>
                  <p class="mt-1 tracking-tight text-brand-900">Fly phishing</p>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-05T3:00PM-08:00">3:00PM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-05T4:00PM-08:00">4:00PM</time>
                    <!-- -->PST
                  </p>
                </li>
              </ol>
            </section>
            <section>
              <h3 class="text-2xl font-semibold tracking-tight text-brand-900">
                <time datetime="2022-04-06">April 6</time>
              </h3>
              <p class="mt-1.5 text-base tracking-tight text-brand-900">We close out the event previewing new techniques that are still in development.</p>
              <ol role="list" class="mt-10 space-y-8 bg-white/60 py-14 px-10 text-center shadow-xl shadow-brand-900/5 backdrop-blur">
                <li aria-label="Andrew Greene talking about Neuralink dark patterns at 9:00AM - 10:00AM PST">
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Andrew Greene</h4>
                  <p class="mt-1 tracking-tight text-brand-900">Neuralink dark patterns</p>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-06T9:00AM-08:00">9:00AM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-06T10:00AM-08:00">10:00AM</time>
                    <!-- -->PST
                  </p>
                </li>
                <li aria-label="Heather Terry talking about DALL-E for passports at 10:00AM - 11:00AM PST">
                  <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Heather Terry</h4>
                  <p class="mt-1 tracking-tight text-brand-900">DALL-E for passports</p>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-06T10:00AM-08:00">10:00AM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-06T11:00AM-08:00">11:00AM</time>
                    <!-- -->PST
                  </p>
                </li>
                <li aria-label="Piers Wilkins talking about Quantum password cracking at 11:00AM - 12:00PM PST">
                  <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Piers Wilkins</h4>
                  <p class="mt-1 tracking-tight text-brand-900">Quantum password cracking</p>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-06T11:00AM-08:00">11:00AM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-06T12:00PM-08:00">12:00PM</time>
                    <!-- -->PST
                  </p>
                </li>
                <li aria-label="Lunch talking about null at 12:00PM - 1:00PM PST">
                  <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Lunch</h4>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-06T12:00PM-08:00">12:00PM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-06T1:00PM-08:00">1:00PM</time>
                    <!-- -->PST
                  </p>
                </li>
                <li aria-label="Gordon Sanderson talking about SkyNet is coming at 1:00PM - 2:00PM PST">
                  <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Gordon Sanderson</h4>
                  <p class="mt-1 tracking-tight text-brand-900">SkyNet is coming</p>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-06T1:00PM-08:00">1:00PM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-06T2:00PM-08:00">2:00PM</time>
                    <!-- -->PST
                  </p>
                </li>
                <li aria-label="Kimberly Parsons talking about Dark patterns for the metaverse at 2:00PM - 3:00PM PST">
                  <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Kimberly Parsons</h4>
                  <p class="mt-1 tracking-tight text-brand-900">Dark patterns for the metaverse</p>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-06T2:00PM-08:00">2:00PM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-06T3:00PM-08:00">3:00PM</time>
                    <!-- -->PST
                  </p>
                </li>
                <li aria-label="Richard Astley talking about Knowing the game and playing it at 3:00PM - 4:00PM PST">
                  <div class="mx-auto mb-8 h-px w-48 bg-indigo-500/10"></div>
                  <h4 class="text-lg font-semibold tracking-tight text-brand-900">Richard Astley</h4>
                  <p class="mt-1 tracking-tight text-brand-900">Knowing the game and playing it</p>
                  <p class="mt-1 font-mono text-sm text-slate-500">
                    <time datetime="2022-04-06T3:00PM-08:00">3:00PM</time>
                    <!-- -->-
                    <!-- -->
                    <time datetime="2022-04-06T4:00PM-08:00">4:00PM</time>
                    <!-- -->PST
                  </p>
                </li>
              </ol>
            </section>
          </div>
        </div>
      </div>
    </section>
    """
  end
end
