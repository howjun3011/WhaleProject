import { createApp } from 'vue'
import App from './App.vue'
import router from './router/index'

// Vue.js 및 Vue Router 마운트
createApp(App).use(router)
              .mount('#app')
