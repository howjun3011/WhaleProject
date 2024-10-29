<template>
  <MainHeader />
  <MainCenter />
</template>

<script>
import MainHeader from './components/main/MainHeader.vue'
import MainCenter from './components/main/MainCenter.vue'

export default {
  components: {
    MainHeader,
    MainCenter,
  },
  data() {
    return {
    }
  },
  mounted() {
    this.executeResize();
    this.receiveMessageMain();
    this.checktype();
  },
  methods: {
    // [ Resize ]
		executeResize() {
      document.addEventListener("DOMContentLoaded", this.resize);
      window.addEventListener("resize", this.resize);
    },
		resize() {
      const libraryElement = document.querySelector(".mainLibraryFrame");
      const detailElement = document.querySelector(".mainDetailFrame");
      const headerElement = document.querySelector(".header");
      const footerElement = document.querySelector(".footer");
      const mainElement = document.querySelector('.main');
      const mainContentElement = document.querySelector('.mainContentFrame');
      
      const windowWidth = window.innerWidth;
      const libraryWidth = libraryElement ? libraryElement.offsetWidth : 0;
      const detailWidth = detailElement ? detailElement.offsetWidth : 0;

      const windowHeight = window.innerHeight;
      const headerHeight = headerElement ? headerElement.offsetHeight : 0;
      const footerHeight = footerElement ? footerElement.offsetHeight : 0;

      if (mainElement) {
        mainElement.style.height = `${windowHeight - headerHeight - footerHeight}px`;
      }

      if (mainContentElement) {
        const availableWidth = windowWidth - libraryWidth - detailWidth;
        if (availableWidth > 200) { // Ensure minimum space for mainContentFrame
            mainContentElement.style.width = `${availableWidth}px`;
        } else {
            mainContentElement.style.width = `200px`; // Assign minimum width to avoid collapsing
        }
      }
    },
    
    // [ Get the Data from the Parent Window ]
    receiveMessageMain() {window.addEventListener("message", this.receiveMessage, false);},

    async receiveMessage(event) {
        if (event.data === 'Full') {console.log(event.data);}
        else if (event.data === 'albumDetail') {this.$router.replace('/whale/streaming/detail/album');}
        else if (event.data === 'artistDetail') {this.$router.replace('/whale/streaming/detail/artist');}
        else if (event.data === 'current') {this.$router.replace('/whale/streaming/current-playlist');}
        else {await this.sendDeviceId(event);}
    },

    async sendDeviceId(event) {
        sessionStorage.device_id = event.data;

        const body = {
            device_id: sessionStorage.device_id,
        };
        fetch(`/whale/streaming/getDeviceId`, {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            method: 'POST',
            body: JSON.stringify(body)
        })
        .then((response) => response.json())
        .then((data) => {
            sessionStorage.accessToken = data.accessToken;
            console.log("Success fetching device id to the Node js Wep App");
        })
        .catch((error) => console.error("Failed to fetch the device_id: ", error));
    },

    checktype() {
      let type;

      fetch(`/whale/streaming/getType`, {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            method: 'GET'
        })
        .then((response) => response.json())
        .then((data) => {
            type = data.type;

            if (type === 'album') {this.$router.replace('/whale/streaming/detail/album');}
            else if (type === 'artist') {this.$router.replace('/whale/streaming/detail/artist');}
            else if (type === 'current') {this.$router.replace('/whale/streaming/current-playlist');}
            else {this.$router.replace('/whale/streaming/recommend');}
        })
    },
  },
};
</script>

<style>
  * {margin: 0; padding: 0; box-sizing: 0;}
  body {min-height: 100vh; -ms-overflow-style: none;}
  ::-webkit-scrollbar {display: none;}
</style>