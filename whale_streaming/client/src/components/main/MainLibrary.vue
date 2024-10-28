<template>
    <div class="mainLibraryFrame" :style="{ width: isExpanded ? '420px' : '110px' }">
        <div class="mainLibrary" :style="{ width: isExpanded ? '88%' : '62%' }">
            <svg data-encore-id="icon" role="img" aria-hidden="true" viewBox="0 0 24 24" class="libraryBtn" @click="expandLibrary()"><path d="M14.5 2.134a1 1 0 0 1 1 0l6 3.464a1 1 0 0 1 .5.866V21a1 1 0 0 1-1 1h-6a1 1 0 0 1-1-1V3a1 1 0 0 1 .5-.866zM16 4.732V20h4V7.041l-4-2.309zM3 22a1 1 0 0 1-1-1V3a1 1 0 0 1 2 0v18a1 1 0 0 1-1 1zm6 0a1 1 0 0 1-1-1V3a1 1 0 0 1 2 0v18a1 1 0 0 1-1 1z"></path></svg>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            isExpanded: false,
        };
    },
    methods: {
        expandLibrary() {
            this.isExpanded = !this.isExpanded;
        },
    },
};
</script>

<style scoped>
    .mainLibraryFrame {display: flex; justify-content: center; align-items: center; height: 100%; background-color: #1f1f1f;}
    .mainLibrary {display: flex; justify-content: center; height: 96%; background-color: #2e2e2e; border-radius: 12px;}
    .libraryBtn {height: 22px; fill: #9f9f9f; margin-top: 15px;}
    .libraryBtn:hover {opacity: 0.8; cursor: grab;}
    .libraryBtn:active {opacity: 0.6; cursor: grab;}
</style>