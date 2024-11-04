<template>
    <div class="playlistDetail">
        <div class="playlistDetailContainer" v-if="playlist !== null">
            <img :src="playlist.images[0].url" :alt="playlist.name" width="170"
                        height="170" style="border-radius: 8px;">
            <div class="playlistDetailInfo">
                <p class="detailSort">플레이리스트</p>
                <p class="playlistName">{{ playlist.name }}</p>
                <p class="playlistDesc">{{ deleteTag(playlist.description) }}</p>
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
                @click="playPlayer(playlist.uri)"
            >
                <path d="m7.05 3.606 13.49 7.788a.7.7 0 0 1 0 1.212L7.05 20.394A.7.7 0 0 1 6 19.788V4.212a.7.7 0 0 1 1.05-.606z"
                ></path>
            </svg>
        </div>
    </div>
    <div class="playlist-tracks" style="height: 25px; margin-top: 5px; pointer-events: none;">
        <div class="playlist-tracks-top" style="justify-content: center;">#</div>
        <div class="playlist-tracks-top" style="padding-left: 5px;">제목</div>
        <div class="playlist-tracks-top" style="padding-left: 5px;">앨범</div>
        <div class="playlist-tracks-top" style="justify-content: center;">시간</div>
    </div>
    <div v-if="playlist !== null" style="width: 100%; height: 50%; margin-top: 19px;">
        <div class="playlist-tracks" style="padding: 9px 0;" v-for="(item, i) in playlist.tracks.items" :key="i" @mouseover="isShow[i] = true" @mouseleave="isShow[i] = false">
            <div class="playlist-tracks-content" style="justify-content: center;" v-if="!isShow[i]">{{ i+1 }}</div>
            <div class="playlist-tracks-content" style="justify-content: center;" v-if="addIsShow(i)">
                <svg
                    data-encore-id="icon"
                    role="img"
                    aria-hidden="true"
                    viewBox="0 0 24 24"
                    class="playlistTrackBtn"
                    style="height: 16px;"
                    @click="playPlayer(item.track.uri)"
                >
                    <path d="m7.05 3.606 13.49 7.788a.7.7 0 0 1 0 1.212L7.05 20.394A.7.7 0 0 1 6 19.788V4.212a.7.7 0 0 1 1.05-.606z"
                    ></path>
                </svg>
            </div>
            <div class="playlist-tracks-content" style="padding-left: 5px;">
                <img :src="item.track.album.images[0].url" alt="item.track.name" height="40" style="border-radius: 2px; margin-right: 10px;">
                <span style="cursor: pointer;" @click="redirectRouter('track',item.track.id)">{{ item.track.name }}</span>&nbsp;/&nbsp;<span style="cursor: pointer;" @click="redirectRouter('artist',item.track.artists[0].id)">{{ item.track.artists[0].name }}</span>
            </div>
            <div class="playlist-tracks-content" style="padding-left: 5px; font-size: 13px; cursor: pointer;" @click="redirectRouter('album',item.track.album.id)">{{ item.track.album.name }}</div>
            <div class="playlist-tracks-content" style="justify-content: center; font-size: 12px;">{{ String(Math.floor(( item.track.duration_ms / (1000 * 60 )) )).padStart(2, "0") }}분 {{ String(Math.floor(( item.track.duration_ms % (1000 * 60 )) / 1000 )).padStart(2, "0") }}초</div>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            playlist: null,
            isShow: [],
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
                } else {
                    console.error('No items found');
                }
            } else {
                console.error('Failed to fetch user top items:', result.statusText);
            }
        },
        async playPlayer(i) {
            await fetch(`/whale/streaming/play?uri=${ i }&device_id=${ sessionStorage.device_id }`);
        },
        getRandomColor() {
            // 랜덤 RGB 색상 생성 함수
            const r = Math.floor(Math.random() * 256);
            const g = Math.floor(Math.random() * 256);
            const b = Math.floor(Math.random() * 256);
            console.log("Generated RGB values:", r, g, b);
            return `rgb(${r}, ${g}, ${b})`;
        },
        changeBackground() {
            document.querySelector('.mainContent').style.backgroundImage = `linear-gradient(${this.getRandomColor()} 10%, rgb(17, 18, 17) 90%)`;
        },
        addIsShow(i) {
            this.isShow.push(false);
            return this.isShow[i];
        },
        deleteTag(i) {
            // a 태그를 찾아 제거
            const parser = new DOMParser();
            const parsedContent = parser.parseFromString(i, 'text/html');
            const links = parsedContent.querySelectorAll("a");

            // 각 a 태그를 순회하며 텍스트만 남기기
            links.forEach(link => {
                const textNode = document.createTextNode(link.textContent);
                link.replaceWith(textNode);
            });

            // 수정된 내용을 다시 playlistDesc에 반영
            return parsedContent.body.innerHTML;
        },
        redirectRouter(i,y) {
            this.$router.replace(`/whale/streaming/detail/${i}/${y}`);
        },
    },
};
</script>

<style scoped>
    .playlistDetail {display: flex; align-items: center; width: 100%; height: 35%;}
    .playlistDetailContainer {display: flex; gap: 20px; color: white; align-items: end; width: 100%; padding-left: 20px; overflow-x: scroll; -ms-overflow-style: none;}
    .playlistDetailInfo {width: 75%; height: 170px; overflow: auto; white-space: nowrap; text-overflow: ellipsis;}
    .detailSort {margin-top: 20px; margin-left: 2px; font-size: 12px; font-weight: 200; letter-spacing: 0.3px; opacity: 0.7;}
    .playlistName {font-size: 64px; font-weight: 400; letter-spacing: 0.4px; opacity: 0.8;}
    .playlistDesc {font-size: 12px; font-weight: 300; letter-spacing: 0.2px; opacity: 0.8;}
    .playlistOpt {margin-top: 5px; font-size: 14px; font-weight: 400; letter-spacing: 0.2px; opacity: 0.8;}
    .playlistFunction {width: 100%;}
    .playlistBtnCircle {display: flex; justify-content: center; align-items: center; width: 50px; height: 50px; margin-left: 30px; border-radius: 50%; background-color: rgb(30, 214, 96);}
    .playlistBtnCircle:hover {opacity: 0.8;}
    .playlistBtnCircle:active {opacity: 0.6;}
    .playlistBtn {height: 22px;}
    .playlist-tracks {position: relative; display: grid; grid-template-columns: 7% 48% 35% 10%; width: 100%;}
    .playlist-tracks:hover {border-radius: 5px; background-color: #5e5e5e;}
    .playlist-tracks-top {display: flex; align-items: center; height: 25px; border-bottom: 1.5px solid #c6c6c6; padding-top: 10px; padding-bottom: 6px; font-size: 13px; color: #ffffff; font-weight: 300; letter-spacing: 0.2px; opacity: 0.8;}
    .playlist-tracks-content {display: flex; align-items: center; height: 32px; color: #ffffff; font-size: 14px; font-weight: 300; letter-spacing: 0.2px; opacity: 0.8;}
    .playlistTrackBtn:hover {opacity: 0.8;}
    .playlistTrackBtn:active {opacity: 0.6;}
</style>