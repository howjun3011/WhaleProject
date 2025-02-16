const MainHeaderMenuComponent = {
	template: `
		<Transition name="menuTransition">
			<div class="headerMenu-wrap" v-if="headerMenuCheck[0]" @click="closeMenu()">
				<div class="headerMenu-containers" @click.stop="">
					<div class="headerMenu-container" id="headerMenu-alarm" v-if="headerMenuCheck[1]">
						<div class="header-contents flexCenter" @click="toggleExpand(0)" :style="{backgroundColor: notificationIndex === 0 ? '#efefef' : '#FCFCFC'}"><p class="header-alarm-content">메시지</p></div>
						<Transition name="menuTransition"><div v-if="notificationIndex === 0" class="header-expanded-content"></div></Transition>
						<div class="header-contents flexCenter" @click="toggleExpand(1)" :style="{backgroundColor: notificationIndex === 1 ? '#efefef' : '#FCFCFC'}"><p class="header-alarm-content">좋아요</p></div>
						<Transition name="menuTransition">
							<div v-if="notificationIndex === 1" class="header-expanded-content">
								<div class="header-notification flexCenter" v-for="(notification, j) in notifications[1]" :key="j"><p class="header-notification-content"><span style="font-weight: 400;">{{ notifications[1][j].target_user_id }}</span>님이 당신의 {{ notifications[1][j].like_noti_type }}에 <span style="font-weight: 400;">좋아요</span>를 눌렀습니다.</p></div>
							</div>
						</Transition>
						<div class="header-contents flexCenter" @click="toggleExpand(2)" :style="{backgroundColor: notificationIndex === 2 ? '#efefef' : '#FCFCFC'}"><p class="header-alarm-content">댓글</p></div>
						<Transition name="menuTransition"><div v-if="notificationIndex === 2" class="header-expanded-content"></div></Transition>
						<div class="header-contents flexCenter" @click="toggleExpand(3)" :style="{backgroundColor: notificationIndex === 3 ? '#efefef' : '#FCFCFC'}"><p class="header-alarm-content">팔로우</p></div>
						<Transition name="menuTransition"><div v-if="notificationIndex === 3" class="header-expanded-content"></div></Transition>
					</div>
					<div class="headerMenu-container" id="headerMenu-profile" v-if="headerMenuCheck[2]">
						<div class="header-contents flexCenter" style="height: 60px; background-color: #f9f9f9; pointer-events: none;"><p class="header-nick-content">{{ userNickname }}님</p></div>
						<div class="header-contents flexCenter" @click="redirectIframe(0,4)"><p class="header-profile-content">마이페이지</p></div>
						<div class="header-contents flexCenter" @click="redirectIframe(2,5)"><p class="header-profile-content">설정</p></div>
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
		this.getLikeNoti();
	},
	methods: {
		closeMenu() {this.$emit('header-close-menu'); this.notificationIndex = null;},
		redirectIframe(i,j) {this.$emit('menu-redirect-iframe',i,j);},
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
		getLikeNoti() {
			fetch('main/likeNoti')
				.then(response => response.json())
				.then(data => {
					this.notifications[1] = data;
			});
		},
	},
};

export default MainHeaderMenuComponent;