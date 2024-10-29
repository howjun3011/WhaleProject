import { createApp } from 'https://unpkg.com/vue@3/dist/vue.esm-browser.js';
import MainHeaderComponent from './components/MainHeaderComponent.js';
import MainHeaderMenuComponent from './components/MainHeaderMenuComponent.js';
import MainCenterComponent from './components/MainCenterComponent.js';
import MainFooterComponent from './components/MainFooterComponent.js';

const app = createApp({
	data() {
		return {
			headerMenuCheck: [false, false, false],
			frameNames: ['leftIframe','rightIframe'],
			whaleAddress: ['streaming','message/home','communityHome','feedHome','profile','settingHome','communityDetail','feedDetail','profileHome'],
			userInfo: [],
			startPage: [ null, null ],
			pageAccess: [],
			notifications: [[],[],[],[]],
			notiCounts: [0,0,0,0],
		}
	},
	mounted() {
		this.executeResize();
		this.getIframeData();
		this.checkUserInfo();
		this.checkPageAccess();
		this.getNotification();
	},
	methods: {
		// [ Resize ]
		executeResize() {$(document).ready(() => {this.resize();}); $(window).resize(() => {this.resize();});},
		resize() {var windowHeight = $(window).height(); var headerHeight = $(".header").height(); var footerHeight = $(".footer").height()+$(".footerMargin").height(); $('.main').css({'height': (windowHeight-headerHeight-footerHeight-1)+'px'});},
		
		// [ iframe 자식 창 데이터 수신 ]
		getIframeData() {
			window.addEventListener('message', (event) => {
				if (event.origin === 'http://localhost:9002') { // 보안을 위해 출처를 확인.
					if (event.data === 'profileEdit') {
						this.checkUserInfo();
						console.log('Received message from iframe window:', event.data);
					}
				}
			});
		},
		
		// [ iframe ]
		fetchIframe(whichIframe,data) {try {document.querySelector('#'+whichIframe).contentWindow.postMessage(data,'https://localhost:5500');} catch (error) {}},

		// [ Props ]
		async fetchWebApi(endpoint, method, body) {const res = await fetch(`https://api.spotify.com/${endpoint}`, {headers: {Authorization: `Bearer ${sessionStorage.accessToken}`,},method,body: JSON.stringify(body)}); return res.json();},
		
		// [ Main Header ]
		menuCheck(i) {if (this.headerMenuCheck[0] === true && this.headerMenuCheck[i] === false) {this.closeMenu();} this.headerMenuCheck[0] = !this.headerMenuCheck[0]; this.headerMenuCheck[i] = !this.headerMenuCheck[i];},
		closeMenu() {this.headerMenuCheck.forEach((element, index) => {if (element === true) {this.headerMenuCheck[index] = false;}})},
		
		// [ Main Header Menu ]
		changeRedirectIndex(i,j,k) {this.replaceIframe(this.pageAccess[i],j,k); this.closeMenu(); setTimeout(() => {this.getNotification();}, 500);},
		
		// [ Main Center ]
		replaceIframe(i,j,k) {$("#"+this.frameNames[i]).get(0).contentWindow.location.replace(this.whaleAddress[j]+k); if (j === 0) {setTimeout(() => {this.fetchIframe(this.frameNames[i],sessionStorage.device_id);}, 1000);}},
		
		// [ User Info ]
		checkUserInfo() {
			fetch('main/userInfo')
				.then(response => response.json())
				.then(data => {
					this.userInfo[0] = data.nickname;
					this.userInfo[1] = data.imageUrl;
			});
		},
		
		// [ Page Access Setting ]
		checkPageAccess() {
			fetch('main/checkPageAccess')
				.then(response => response.json())
				.then(data => {
					this.pageAccess[0] = data.page_access_mypage;
					this.pageAccess[1] = data.page_access_notification;
					this.pageAccess[2] = data.page_access_setting;
					this.pageAccess[3] = data.page_access_music;
			});
		},
		
		// [ Notification ]
		getNotification() {
			// 메세지
			this.notifications[0] = [];
			this.notiCounts[0] = this.notifications[0].length;
			// 좋아요
			fetch('main/likeNoti')
				.then(response => response.json())
				.then(data => {
					this.notifications[1] = data;
					this.notiCounts[1] = this.notifications[1].filter(notification => notification.like_noti_check === 0).length;
					console.log(data);
			});
			// 댓글
			fetch('main/commentsNoti')
				.then(response => response.json())
				.then(data => {
					this.notifications[2] = data;
					this.notiCounts[2] = this.notifications[2].filter(notification => notification.comments_noti_check === 0).length;
					console.log(data);
			});
			// 팔로우
			fetch('main/followNoti')
				.then(response => response.json())
				.then(data => {
					this.notifications[3] = data;
					this.notiCounts[3] = this.notifications[3].filter(notification => notification.follow_noti_check === 0).length;
					console.log(data);
			});
		},
	},
});

app.component("MainHeaderComponent",MainHeaderComponent);
app.component("MainHeaderMenuComponent",MainHeaderMenuComponent);
app.component("MainCenterComponent",MainCenterComponent);
app.component("MainFooterComponent",MainFooterComponent);

app.mount('#main');