const MainHeaderMenuComponent = {
	template: `
		<Transition name="menuTransition">
			<div class="headerMenu-wrap" v-if="headerMenuCheck[0]" @click="closeMenu()">
				<div class="headerMenu-containers" @click.stop="">
					<div class="headerMenu-container" id="headerMenu-alarm" v-if="headerMenuCheck[1]">
						<div class="header-contents flexCenter" @click="toggleExpand(0)" :style="{backgroundColor: notificationIndex === 0 && notifications[0].length !== 0 ? '#efefef' : '#FCFCFC'}"><p class="header-alarm-content">메시지</p></div>
						<Transition name="menuTransition"><div v-if="notificationIndex === 0 && notifications[0].length !== 0" class="header-expanded-content"></div></Transition>
						
						<div class="header-contents flexCenter" @click="toggleExpand(1)" :style="{backgroundColor: notificationIndex === 1 && notifications[1].length !== 0 ? '#efefef' : '#FCFCFC'}"><p class="header-alarm-content">좋아요</p></div>
						<Transition name="menuTransition">
							<div v-if="notificationIndex === 1 && notifications[1].length !== 0" class="header-expanded-content">
								<div class="header-notification flexCenter" v-for="(notification, j) in notifications[1]" :key="j" @click="redirectIframe(1,6,'?c='+notification.community_id+'&p='+notification.post_id)"><p class="header-notification-content"><span style="font-weight: 400;">{{ notifications[1][j].target_user_id }}</span>님이 당신의 {{ notifications[1][j].like_noti_type }}에 <span style="font-weight: 400;">좋아요</span>를 눌렀습니다.</p></div>
							</div>
						</Transition>
						
						<div class="header-contents flexCenter" @click="toggleExpand(2)" :style="{backgroundColor: notificationIndex === 2 && notifications[2].length !== 0 ? '#efefef' : '#FCFCFC'}"><p class="header-alarm-content">댓글</p></div>
						<Transition name="menuTransition"><div v-if="notificationIndex === 2 && notifications[2].length !== 0" class="header-expanded-content"></div></Transition>
						
						<div class="header-contents flexCenter" @click="toggleExpand(3)" :style="{backgroundColor: notificationIndex === 3 && notifications[3].length !== 0 ? '#efefef' : '#FCFCFC'}"><p class="header-alarm-content">팔로우</p></div>
						<Transition name="menuTransition"><div v-if="notificationIndex === 3 && notifications[3].length !== 0" class="header-expanded-content"></div></Transition>
					</div>
					<div class="headerMenu-container" id="headerMenu-profile" v-if="headerMenuCheck[2]">
						<div class="header-contents flexCenter" style="height: 60px; background-color: #f9f9f9; pointer-events: none;"><p class="header-nick-content">{{ userNickname }}님</p></div>
						<div class="header-contents flexCenter" @click="redirectIframe(0,4,'')"><p class="header-profile-content">마이페이지</p></div>
						<div class="header-contents flexCenter" @click="redirectIframe(2,5,'')"><p class="header-profile-content">설정</p></div>
						<div class="header-contents flexCenter" @click="logoutWhale()" style="border: none; border-bottom-left-radius: 18px; border-bottom-right-radius: 18px;"><p class="header-profile-content">로그아웃</p></div>
					</div>
				</div>
	    	</div>
    	</Transition>
	`,
	props: {
		headerMenuCheck: Array,
		userNickname: String,
	},
	data() {
		return {
			notificationIndex: null,
			notifications: [],
		};
	},
	mounted() {
		this.getNotification();
	},
	methods: {
		closeMenu() {this.$emit('header-close-menu'); this.notificationIndex = null;},
		redirectIframe(i,j,k) {this.$emit('menu-redirect-iframe',i,j,k); this.notificationIndex = null;},
		redirectIframeNoti(i,j,k) {
			let x;
			if (this.notifications[1][k].post_id !== 0) {x = `?c=${notification.community_id}&p=${notification.post_id}`;}
			else if (this.notifications[1][k].feed_id !== 0) {x = `?c=${notification.community_id}&p=${notification.post_id}`;}
			this.$emit('menu-redirect-iframe',i,j,x);
			this.notificationIndex = null;
		},
		logoutWhale() {
			// 스프링 클라이언트 정보 초기화
			localStorage.clear();
			// 스프링 서버 정보 초기화
			location.href='/whale/main/logout';
		},
		toggleExpand(i) {
			this.notificationIndex = this.notificationIndex === i ? null : i;
		},
		// [ Like Notification ]
		getNotification() {
			// 메세지
			this.notifications[0] = [];
			// 좋아요
			fetch('main/likeNoti')
				.then(response => response.json())
				.then(data => {
					this.notifications[1] = data;
					console.log(data);
			});
			// 댓글
			fetch('main/commentsNoti')
				.then(response => response.json())
				.then(data => {
					this.notifications[2] = data;
					console.log(data);
			});
			// 팔로우
			this.notifications[3] = [];
		},
	},
};

export default MainHeaderMenuComponent;