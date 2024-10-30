<template>
    <div class="playlist-container">
        <h1>Playlist Detail</h1>
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
    },
    methods: {
        async getUserPlaylists() {
            const result = await fetch(`/whale/streaming/getPlaylist?id=${this.$route.params.id}`);
            if (await result.ok) {
                const data = await result.json();
                this.playlist = data;
                console.log('Complete: ',this.playlist);
            } else {
                console.error('Failed to fetch user top items:', result.statusText);
            }
        },
    },
};
</script>

<style>
    .playlist-container {display: flex; justify-content: center; align-items: center; width: 100%; height: 100%;}
</style>