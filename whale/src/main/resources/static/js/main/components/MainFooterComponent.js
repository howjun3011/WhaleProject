const MainFooterComponent = {
	template: `
		<div class="footer flexCenter">
	        <div class="player">
	        	<div class="playerComponent" id="playerLeft">
	        		<div class="flexCenter"><img :src="trackInfo[0]" alt="" height="48px" style="border-radius: 5px; opacity: 0.9;"></div>
	        		<div class="playerRightStyle"><p class="playerTrackName">{{ trackInfo[1] }}</p><p class="playerArtistName">{{ trackInfo[2] }}</p></div>
	        		<div class="playerRightStyle" @click="insertTrack()"><img class="playerImg" src="static/images/streaming/player/like.png" alt="Music Whale Like Button" width="23px" height="23px" :style="{backgroundColor: trackInfo[3] ? '#efefef' : '#FCFCFC'}"></div>
	        	</div>
	            <div class="playerComponent flexCenter">
	            	<button class="playerBtn flexCenter" @click="shufflePlay()"><img class="playerImg" src="static/images/streaming/player/shuffle.png" alt="Music Whale Shuffle Button" height="32px" :style="{backgroundColor: isShuffled ? '#F5F5F5' : '#FCFCFC'}"></button>
	                <button class="playerBtn flexCenter" @click="prevPlay()"><img src="static/images/streaming/player/prev.png" alt="Music Whale Previous Button" height="42px"></button>
	                <button class="playerBtn flexCenter" @click="togglePlay()"><img :src="playBtnSrc[playBtnSrcIndex]" alt="Music Whale Play Button" height="42px"></button>
	                <button class="playerBtn flexCenter" @click="nextPlay()"><img src="static/images/streaming/player/next.png" alt="Music Whale Next Button" height="42px"></button>
	                <button class="playerBtn flexCenter" @click="repeatPlay()" style="position: relative;"><img class="playerImg" :src="repeatBtnSrc[repeatBtnSrcIndex]" alt="Music Whale Repeat Button" height="32px" :style="{backgroundColor: isRepeated ? '#F5F5F5' : '#FCFCFC'}"></button>
	            </div>
	            <div class="playerComponent" id="playerRight">
	            	<div class="playerRightMargin"><img class="playerFullScreenImg" src="static/images/streaming/player/fullScreenBtn.png" alt="Music Whale Full Screen Button" width="24px" height="24px"></div>
	            	<div class="playerRightMargin"><img class="playerPlayListImg" src="static/images/streaming/player/playlist.png" alt="Music Whale Playlist Button" width="34px" height="34px"></div>
	            </div>
	        </div>
	    </div>
	    <div class="footerMargin"></div>
	`,
	props: {
		fetchIframe: {type: Function, default() {return 'Default function'}},
		fetchWebApi: {type: Function, default() {return 'Default function'}},
		startPage: Array,
	},
	data() {
		return {
			player: null,
			playbackState: null,
			trackInfo: [],
			playBtnSrc: ['static/images/streaming/player/play.png','static/images/streaming/player/pause.png'],
			playBtnSrcIndex: 0,
			repeatBtnSrc: ['static/images/streaming/player/repeat.png','static/images/streaming/player/repeatOnce.png'],
			repeatBtnSrcIndex: 0,
			isRepeated: false,
			isShuffled: false,
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
			        this.trackInfo[3] = false;
			        
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
						}
					);
			    });
			}
		},
		
		async insertTrack() {
			this.trackInfo[3] = true;
            try {
                const body = {
                    trackArtist: this.playbackState.items[0].track.artists[0].name,
                    trackName: this.playbackState.items[0].track.name,
                    trackAlbum: this.playbackState.items[0].track.album.name,
                    trackCover: this.playbackState.items[0].track.album.images[0].url,
                    trackSpotifyId: this.playbackState.items[0].track.id,
                };
                const response = await fetch('streaming/insertTrack', {
                    headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json'
                    },
                    method: 'POST',
                    body: JSON.stringify(body)
                });
                
                if (response.ok) {
					console.log("Success inserting Data to the Spring Wep App");
		        } else {
		            console.error('Failed to insert the track info: ', response.statusText);
		        }
            } catch (error) {
                console.error('Error while fetching the track info:', error);
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
		
		async shufflePlay() {
			if (this.isShuffled) {try {await this.fetchWebApi(`v1/me/player/shuffle?state=${false}&device_id=${sessionStorage.device_id}`,'PUT');} catch(error) {}}
			else {try {await this.fetchWebApi(`v1/me/player/shuffle?state=${true}&device_id=${sessionStorage.device_id}`,'PUT');} catch(error) {}}
		},
		togglePlay() {if (this.playBtnSrcIndex === 1) {this.playBtnSrcIndex = 0;} else {this.playBtnSrcIndex = 1;} this.player.togglePlay();},
		nextPlay() {
			this.player.getCurrentState().then(
				async (state) => {
					if (state.track_window.next_tracks[0] === undefined) {
						try {const data = await this.fetchWebApi(`v1/recommendations?limit=1&seed_tracks=${state.track_window.current_track.id}`,'GET'); await this.fetchWebApi(`v1/me/player/play?device_id=${sessionStorage.device_id}`,'PUT',{ "uris": [`${data.tracks[0].uri}`] });} catch(error) {}
					} else {
						this.player.nextTrack();
						console.log("next");
					}
				}
			);
		},
		prevPlay() {this.player.previousTrack();},
		async repeatPlayFunction(state) {try {await this.fetchWebApi(`v1/me/player/repeat?state=${state}&device_id=${sessionStorage.device_id}`,'PUT');} catch(error) {}},
		async repeatPlay() {
			if (this.repeatBtnSrcIndex === 1 && this.isRepeated) {await this.repeatPlayFunction('off');}
			else if (this.repeatBtnSrcIndex === 0 && this.isRepeated) {await this.repeatPlayFunction('track');}
			else {await this.repeatPlayFunction('context');}
		},
	},
};

export default MainFooterComponent;
