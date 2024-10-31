const MainFooterComponent = {
	template: `
		<div>
		<div class="footer flexCenter">
	        <div class="player">
	        	<div class="playerComponent" id="playerLeft">
	        		<div class="playerInfo flexCenter" @click="sendStreaming('albumDetail','?type=album')"><img :src="trackInfo[0]" alt="" height="48px" style="border-radius: 5px; opacity: 0.9;"></div>
	        		<div class="playerRightStyle"><p class="playerTrackName playerInfo" @click="sendStreaming('albumDetail','?type=album')">{{ trackInfo[1] }}</p><p class="playerArtistName playerInfo" @click="sendStreaming('artistDetail','?type=artist')">{{ trackInfo[2] }}</p></div>
	        		<div class="playerRightStyle" @click="insertTrackLike()"><img class="playerImg" :src="isLiked[ trackInfo[5] ? 1 : 0]" alt="Music Whale Like Button" width="23px" height="23px"></div>
	        	</div>
	        	<div class="playerComponent flexCenter">
	        		<div class="player-bar">
			            <input type="range" id="seek-bar" min="0" max="100" value="0">
			        </div>
	        	</div>
	            <div class="playerComponent flexCenter">
	            	<button class="playerBtn flexCenter" @click="shufflePlay()"><img class="playerImg" src="static/images/streaming/player/shuffle.png" alt="Music Whale Shuffle Button" height="32px" :style="{backgroundColor: isShuffled ? '#F5F5F5' : '#FCFCFC'}"></button>
	                <button class="playerBtn flexCenter" @click="prevPlay()"><img src="static/images/streaming/player/prev.png" alt="Music Whale Previous Button" height="42px"></button>
	                <button class="playerBtn flexCenter" @click="togglePlay()"><img :src="playBtnSrc[playBtnSrcIndex]" alt="Music Whale Play Button" height="42px"></button>
	                <button class="playerBtn flexCenter" @click="nextPlay()"><img src="static/images/streaming/player/next.png" alt="Music Whale Next Button" height="42px"></button>
	                <button class="playerBtn flexCenter" @click="repeatPlay()" style="position: relative;"><img class="playerImg" :src="repeatBtnSrc[repeatBtnSrcIndex]" alt="Music Whale Repeat Button" height="32px" :style="{backgroundColor: isRepeated ? '#F5F5F5' : '#FCFCFC'}"></button>
	            </div>
	            <div class="playerComponent"></div>
	            <div class="playerComponent" id="playerRight">
	            	<div class="playerRightMargin"><img class="playerFullScreenImg" src="static/images/streaming/player/fullScreenBtn.png" alt="Music Whale Full Screen Button" width="24px" height="24px"></div>
	            	<div class="playerRightMargin"><img class="playerPlayListImg playerInfo" src="static/images/streaming/player/playlist.png" alt="Music Whale Playlist Button" width="34px" height="34px" @click="sendStreaming('current','?type=current')"></div>
	            	<div class="volume-bar">
			            <input type="range" id="volume-slider" min="0" max="100" value="50">
			        </div>
	            </div>
	        </div>
	    </div>
	    <div class="footerMargin"></div>
	    </div>
	`,
	props: {
		fetchIframe: {type: Function, default() {return 'Default function'}},
		fetchWebApi: {type: Function, default() {return 'Default function'}},
		startPage: Array,
	},
	data() {
		return {
			player: null,
			trackInfo: [],
			playBtnSrc: ['static/images/streaming/player/play.png','static/images/streaming/player/pause.png'],
			playBtnSrcIndex: 0,
			repeatBtnSrc: ['static/images/streaming/player/repeat.png','static/images/streaming/player/repeatOnce.png'],
			repeatBtnSrcIndex: 0,
			isRepeated: false,
			isShuffled: false,
			isLiked: ['static/images/streaming/player/like.png','static/images/streaming/player/likeFill.png']
		};
	},
	mounted() {
		this.playerOn();
	},
	methods: {
		playerOn() {
			window.onSpotifyWebPlaybackSDKReady = () => {
				this.player = new Spotify.Player({
			        name: 'Whale Player',
			        getOAuthToken: cb => { cb(sessionStorage.accessToken); },
			        volume: 0.5
			    });
			    
			    // [ Connection ]
			    this.player.connect().then(success => {
			        if (success) {
			            console.log('The Web Playback SDK successfully connected to Spotify!');
			        }
			    });
			    
			    // [ Ready ]
			    this.player.addListener('ready', ({ device_id }) => {
					sessionStorage.device_id = device_id;
					
					// [ The Spring Web App ]
					(async () => {await this.fetchData(`http://localhost:9002/whale/main/device_id`);})();
					
					// [ The Node js Web App ]
					if (this.startPage[0] === 'streaming') {this.fetchIframe('leftIframe',sessionStorage.device_id);}
					if (this.startPage[1] === 'streaming') {this.fetchIframe('rightIframe',sessionStorage.device_id);}
					
					(async () => {try {await this.fetchWebApi(`v1/me/player`,'PUT',{ device_ids: [ sessionStorage.device_id ]});} catch(error) {}})();
					
			        console.log('Ready with Device ID', device_id);
			    });
			    
			    // [ Not Ready ]
			    this.player.addListener('not_ready', ({ device_id }) => {
			        console.log('Device ID has gone offline', device_id);
			    });
			
			    this.player.addListener('initialization_error', ({ message }) => {
			        console.error(message);
			    });
			
			    this.player.addListener('authentication_error', ({ message }) => {
			        console.error(message);
			    });
			
			    this.player.addListener('account_error', ({ message }) => {
			        console.error(message);
			    });
			    
			    // [ Player State Changed ]
			    this.player.addListener('player_state_changed', ({
			        track_window: { current_track }
			    }) => {
			        this.trackInfo[0] = current_track.album.images[0].url;
			        this.trackInfo[1] = current_track.name;
			        this.trackInfo[2] = current_track.artists[0].name;
			        this.trackInfo[3] = current_track.album.name;
			        this.trackInfo[4] = current_track.id;
			        
			        this.player.getCurrentState().then(
						(state) => {
							// [ 재생 중이라면 버튼 이미지 정지 버튼 변환 ]
							if (!state.paused && this.playBtnSrcIndex === 0) {this.playBtnSrcIndex = 1;}
							// [ 일회 반복 중이라면 버튼 이미지 변환 ]
							if (state.repeat_mode === 2) {this.repeatBtnSrcIndex = 1; this.isRepeated = true;}
							else if (state.repeat_mode === 1) {this.repeatBtnSrcIndex = 0; this.isRepeated = true;}
							else {this.repeatBtnSrcIndex = 0; this.isRepeated = false;}
							// [ 셔플 중이라면 버튼 배경 이미지 변환 ]
							if (state.shuffle_mode === 1) {this.isShuffled = true;}
							else {this.isShuffled = false;}
							
							fetch(`/whale/streaming/currentTrackInfo`, {
								headers: {
									'Accept': 'application/json',
						            'Content-Type': 'application/json'
						        },
						        method: 'POST',
						        body: JSON.stringify({
									artistName: state.track_window.current_track.artists[0].name,
									trackName: state.track_window.current_track.name,
									albumName: state.track_window.current_track.album.name,
									trackCover: state.track_window.current_track.album.images[0].url,
									trackSpotifyId: state.track_window.current_track.id
								})
							})
							.then(response => response.json())
								.then(data => {
									if (data.result === 'yes') {this.trackInfo[5] = true;}
									else {this.trackInfo[5] = false;}
							});
						}
					);
			    });
			}
		},
		
		async insertTrackLike() {
			let x;
			
			if (this.trackInfo[5] === false) {x = 'insertTrackLike';}
			else {x = 'deleteTrackLike';}
			
            try {
                const body = {
                    artistName: this.trackInfo[2],
					trackName: this.trackInfo[1],
					albumName: this.trackInfo[3],
					trackCover: this.trackInfo[0],
					trackSpotifyId: this.trackInfo[4]
                };
                const response = await fetch(`streaming/${ x }`, {
                    headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json'
                    },
                    method: 'POST',
                    body: JSON.stringify(body)
                });
                
                if (response.ok) {
					console.log("Success updating Track Like Data to the Spring Wep App");
		        } else {
		            console.error('Failed to update the  Track Like Data: ', response.statusText);
		        }
            } catch (error) {
                console.error('Error while fetching the  Track Like Data:', error);
            }
            
            this.trackInfo[5] = !this.trackInfo[5];
        },
        
        async insertTrackCnt() {
            try {
                const body = {
                    artistName: this.trackInfo[2],
					trackName: this.trackInfo[1],
					albumName: this.trackInfo[3],
					trackCover: this.trackInfo[0],
					trackSpotifyId: this.trackInfo[4]
                };
                const response = await fetch(`streaming/insertTrackCnt`, {
                    headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json'
                    },
                    method: 'POST',
                    body: JSON.stringify(body)
                });
                
                if (response.ok) {
					console.log("Success updating Track Cnt Data to the Spring Wep App");
		        } else {
		            console.error('Failed to update the  Track Cnt Data: ', response.statusText);
		        }
            } catch (error) {
                console.error('Error while fetching the  Track Cnt Data:', error);
            }
        },
        async fetchData(address) {
			const body = {
				device_id: sessionStorage.device_id,
			};
	        const response = await fetch(`${ address }`, {
		        headers: {
		            'Accept': 'application/json',
		            'Content-Type': 'application/json'
		        },
		        method: 'POST',
		        body: JSON.stringify(body)
	    	});
	        
	        if (response.ok) {
	            console.log("Success fetching Data to the Spring Wep App");
	        } else {
	            console.error('Failed to fetch the device_id: ', response.statusText);
	        }
		},
		
		// 플레이어 기능
		async shufflePlay() {
			if (this.isShuffled) {try {await this.fetchWebApi(`v1/me/player/shuffle?state=${false}&device_id=${sessionStorage.device_id}`,'PUT');} catch(error) {}}
			else {try {await this.fetchWebApi(`v1/me/player/shuffle?state=${true}&device_id=${sessionStorage.device_id}`,'PUT');} catch(error) {}}
		},
		togglePlay() {
			if (this.playBtnSrcIndex === 1) {
				this.playBtnSrcIndex = 0;
			} else {
				this.playBtnSrcIndex = 1;
				this.insertTrackCnt();
			}
			this.player.togglePlay();
		},
		nextPlay() {
			this.player.getCurrentState().then(
				async (state) => {
					if (state.track_window.next_tracks[0] === undefined) {
						try {const data = await this.fetchWebApi(`v1/recommendations?limit=1&seed_tracks=${state.track_window.current_track.id}`,'GET'); await this.fetchWebApi(`v1/me/player/play?device_id=${sessionStorage.device_id}`,'PUT',{ "uris": [`${data.tracks[0].uri}`] }); this.insertTrackCnt();} catch(error) {}
					} else {
						this.player.nextTrack();
						this.insertTrackCnt();
						console.log("next");
					}
				}
			);
		},
		prevPlay() {this.player.previousTrack(); this.insertTrackCnt();},
		async repeatPlayFunction(state) {try {await this.fetchWebApi(`v1/me/player/repeat?state=${state}&device_id=${sessionStorage.device_id}`,'PUT');} catch(error) {}},
		async repeatPlay() {
			if (this.repeatBtnSrcIndex === 1 && this.isRepeated) {await this.repeatPlayFunction('off');}
			else if (this.repeatBtnSrcIndex === 0 && this.isRepeated) {await this.repeatPlayFunction('track');}
			else {await this.repeatPlayFunction('context');}
		},
		
		// 플레이어 정보 송신 기능
		sendStreaming(i,j) {
			let x = $("#leftIframe").get(0).src;
			let y = $("#rightIframe").get(0).src;
			if (x === 'http://localhost:9002/whale/streaming') {this.fetchIframe('leftIframe',i);}
			else if (y === 'http://localhost:9002/whale/streaming') {this.fetchIframe('rightIframe',i);}
			else {this.$emit('footer-music-toggle', 3, 0, j);}
		},
	},
};

export default MainFooterComponent;
