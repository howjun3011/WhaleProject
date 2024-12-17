// Vue Router 관련 객체 생성
import { createMemoryHistory, createRouter } from 'vue-router';

import MainRecommendation from '../components/main/MainRecommendation.vue';
// import MainSearchHome from '../components/main/MainSearchHome.vue';
import MainSearch from '../components/main/MainSearch.vue';
import MainDetailArtist from '../components/main/MainDetailArtist.vue';
import MainDetailAlbum from '../components/main/MainDetailAlbum.vue';
import MainDetailTrack from '../components/main/MainDetailTrack.vue';
import MainPlaylist from '../components/main/MainPlaylist.vue';

// Vue Router 패스 설정
const routes = [
    { path: '/whale/streaming/recommend', component: MainRecommendation },
    // { path: '/whale/streaming/searchHome', component: MainSearchHome },
    { path: '/whale/streaming/search/:query', component: MainSearch },
    { path: '/whale/streaming/detail/artist/:id', component: MainDetailArtist },
    { path: '/whale/streaming/detail/album/:id', component: MainDetailAlbum },
    { path: '/whale/streaming/detail/track/:id', component: MainDetailTrack },
    { path: '/whale/streaming/playlist/:id', component: MainPlaylist },
];

// Vue Router 환경 설정
const router = createRouter({
    history: createMemoryHistory(),
    routes,
});

// Vue Router 검색 홈화면 및 검색 결과 화면 관련 설정
/*
router.beforeEach(function (to, from, next) {
    if (from.path.substring(1).split('/')[2] === 'search' && to.path.substring(1).split('/')[2] === 'searchHome') {
        console.log('Block');
    } else {
        next();
    }
  });
*/

export default router;