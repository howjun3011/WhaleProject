<template>
    <div class="playlistDetail">
        <div class="playlistDetailContainer" v-if="playlist !== null">
            <img :src="playlist.images[0].url" :alt="playlist.name" width="170"
                        height="170" style="border-radius: 8px;">
            <div class="playlistDetailInfo">
                <p class="detailSort">플레이리스트</p>
                <p class="playlistName">{{ playlist.name }}</p>
                <p class="playlistDesc">{{ playlist.description }}</p>
                <p class="playlistOpt">WHALE • {{ playlist.tracks.total }}곡</p>
            </div>
        </div>
    </div>
    <div class="playlistFunction">
        <div class="playlistBtnCircle">
            <svg
                data-encore-id="icon"
                role="img"
                aria-hidden="true"
                viewBox="0 0 24 24"
                class="playlistBtn"
            >
                <path d="m7.05 3.606 13.49 7.788a.7.7 0 0 1 0 1.212L7.05 20.394A.7.7 0 0 1 6 19.788V4.212a.7.7 0 0 1 1.05-.606z"
                ></path>
            </svg>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            playlist: null,
        }
    },
    mounted() {
        this.getUserPlaylists();
        this.changeBackground();
    },
    methods: {
        async getUserPlaylists() {
            const result = await fetch(`/whale/streaming/getPlaylist?id=${this.$route.params.id}`);
            if (await result.ok) {
                const data = await result.json();
                if (data && data.tracks.items.length > 0) {
                    this.playlist = data;
                    console.log('Complete: ',this.playlist);
                } else {
                    console.error('No items found');
                }
            } else {
                console.error('Failed to fetch user top items:', result.statusText);
            }
        },
        changeBackground() {
            document.querySelector('.mainContent').style.backgroundImage = 'linear-gradient(to bottom, rgb(206, 116, 144), rgb(17, 18, 17))';
        },
    },
};
</script>

<style scoped>
    .playlistDetail {display: flex; align-items: center; width: 100%; height: 35%;}
    .playlistDetailContainer {display: flex; gap: 20px; color: white; align-items: end; width: 100%; padding-left: 20px; overflow-x: scroll; -ms-overflow-style: none;}
    .playlistDetailInfo {width: 65%; height: 170px;}
    .detailSort {margin-top: 20px; margin-left: 2px; font-size: 12px; font-weight: 200; letter-spacing: 0.3px; opacity: 0.7;}
    .playlistName {font-size: 64px; font-weight: 400; letter-spacing: 0.4px; opacity: 0.8;}
    .playlistDesc {font-size: 12px; font-weight: 300; letter-spacing: 0.2px; opacity: 0.8;}
    .playlistOpt {margin-top: 5px; font-size: 14px; font-weight: 400; letter-spacing: 0.2px; opacity: 0.8;}
    .playlistFunction {width: 100%;}
    .playlistBtnCircle {display: flex; justify-content: center; align-items: center; width: 50px; height: 50px; margin-left: 30px; border-radius: 50%; background-color: rgb(30, 214, 96);}
    .playlistBtn {height: 22px;}
</style>