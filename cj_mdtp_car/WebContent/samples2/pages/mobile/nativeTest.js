require(
    ['jquery', 'miaps', 'miapswp', 'miaps-modal'],
    function ($, miaps, miapsWp) {
        /*
          Global Variable
         */
        var gWmFlag = false
        var tempPics = ''

        /*
          Execute Event
         */
        /**
         * 워터 마크
         */
        function execWatermark() {
            toastFunc(arguments.callee.name)
            try {
                var pVisible
                if (gWmFlag === false) {
                    pVisible = true
                    gWmFlag = true
                } else {
                    pVisible = false
                    gWmFlag = false
                }

                var parameter = {
                    visible: pVisible,
                    rgb: '50,50,50',
                    fontsize: 48,
                    x: 0,
                    y: 0,
                    angle: 45,
                    transparency: 50,
                    msg: 'Water Mark Display'
                }

                miapsWp.callNative('watermark', parameter, '', function (data) {
                    var obj = miaps.parse(data)
                    if (obj.code === 200) {
                        showModal('Success\n' + JSON.stringify(obj.res))
                    } else {
                        showModal('Fail\n' + JSON.stringify(obj))
                    }
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        function execScan() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {
                    msg: 'scan'
                }
                miapsWp.callNative('scan', parameter, '', function (data) {
                    var obj = miaps.parse(data)
                    if (obj.code === 200) {
                        showModal('Success\n' + JSON.stringify(obj.res))
                    } else {
                        showModal('Fail\n' + JSON.stringify(obj))
                    }
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * 특정 시간 동안 사용이 없을 때 화면 잠금, 또는 특정 페이지 이동
         * (이동은 Miaps Notify Callback에서 직접 구현)
         */
        function execSession() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {
                    'type': 'custom',
                    'second': 1
                }
                miapsWp.callNative('session', parameter, '', null)
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * GPS 경위도 취득
         * start : true(Start GPS), false(Stop GPS)
         * onetime : true(Return을 받고 GPS Stop), false(Stop이 올때까지 반복)
         * type : navigate(Get GPS), best(GPS가 아닌 통신망에서 취득)
         * @return: 경도;위도
         */
        function execGeolocation() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {
                    start: true,
                    onetime: true,
                    type: 'navigate'
                }

                miapsWp.callNative('geolocation', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * 지문 및 Face ID 인식
         * @return: code
         * 8800: 지문 인식 성공
         * 8801: 지문 인식 기능을 지원하지 않을 경우
         * 8802: 지문 인식 기능이 있지만 설정을 하지 않았을 경우
         * 8803: 지문 인식 설정을 했지만 지문 인식에 실패한 경우
         * 8804: 지문 인식 기능이 잠겼을 경우(잦은 실패 등)
         * 8805: 취소 버튼을 눌렀을 경우
         * 8806: 권한이 없는 경우(Android)
         */
        function execFingerStart() {
            toastFunc(arguments.callee.name)
            try {
                miapsWp.callNative('finger', 'start', '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * 지문 인식 장치 지원 여부
         * @return: boolean
         */
        function execFingerCheckDevice() {
            toastFunc(arguments.callee.name)
            try {
                miapsWp.callNative('finger', 'checkdevice', '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * 지문 등록 여부
         * @return: boolean
         */
        function execFingerCheckReg() {
            toastFunc(arguments.callee.name)
            try {
                miapsWp.callNative('finger', 'checkreg', '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * Get App Pakage ID
         * @return: string
         */
        function execAppID() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {}

                miapsWp.callNative('appid', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * Get Bundle ID
         * @return: string
         */
        function execBundleID() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {}

                miapsWp.callNative('bundleid', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * Get App Version
         * @return: string
         */
        function execVersion() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {}

                miapsWp.callNative('version', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * Get OS Language
         * @return: string
         */
        function execLanguage() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {}

                miapsWp.callNative('language', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * Get Device ID
         * @return: string
         */
        function execDeviceID() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {}

                miapsWp.callNative('deviceid', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * Get Device Model
         * @return: string
         */
        function execDeviceModel() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {}

                miapsWp.callNative('devicemodel', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * 사용자 설정 정보 암호화 Write
         * @return: Success/Fail
         */
        function execValueSave() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {
                    'id': 'testid',
                    'pw': 'test123'
                }

                miapsWp.callNative('savevalue', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * 사용자 설정 정보 복호화 Read
         * @return: UserSettingInfo
         */
        function execValueLoad() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = ['id', 'pw']

                miapsWp.callNative('loadvalue', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * SaveValue로 저장한 모든 데이터 삭제
         * @return: string
         */
        function execValueClear() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {}

                miapsWp.callNative('clearallvalue', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * OS 구분값 획득
         * @return: string
         */
        function execPlatform() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {}

                miapsWp.callNative('platform', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * OS 버전 획득
         * @return: string
         */
        function execPlatformVersion() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {}

                miapsWp.callNative('platformversion', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * 단말 설정 시간대 취득
         * @return: string
         */
        function execTimezone() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {}

                miapsWp.callNative('timezone', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        function execIsTablet() {
            toastFunc(arguments.callee.name)
            try {
                miapsWp.callNative('istablet', '', '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * Web Browser 실행
         * @return: string
         */
        function execNewbrowser() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {
                    url: 'http://m.naver.com'
                }

                miapsWp.callNative('newbrowser', parameter, null)
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * 카메라 실행하고 촬영한 사진을 임시 저장
         * @return: 저장경로
         */
        function execCamera() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {
                    path: '${ResourceRoot}/temp'
                }

                miapsWp.callNative('camera', parameter, '', function (data) {
                    execFileList()
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * 앨범을 실행하고 선택한 이미지를 임시 저장
         * @return: 저장경로
         */
        function execGallery() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {
                    path: '${ResourceRoot}/temp'
                }

                miapsWp.callNative('gallery', parameter, '', function (data) {
                    execFileList()
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * 지정한 경로의 파일 목록 취득
         * fullpath: Whole Path
         * filename: File Name
         * size: File Size
         * date: yyyyMMddHHmmss
         * isdir: is Directory(Y/N)
         * ${ResourceRoot}: miaps_hybrid.js의 pathConfig.myFileRoot
         * @return: [{'fullpath':'', 'filename':'', 'size':'', 'date':'', 'isdir':''}]
         */
        function execFileList() {
            toastFunc(arguments.callee.name)
            try {
                /*
                절대 경로(로컬PC): {'path':'C:\xxx\xxx'},
                상대 경로: {'path':'${ResourceRoot}\res'}
                Android 외부 저장소: {'path':'${ExternalRoot}\res'}
               */
                var parameter = {'path': '${ResourceRoot}/temp'}

                miapsWp.callNative('filelist', parameter, '', function (data) {
                    var obj = miaps.parse(data)

                    if (obj.code === 200) {
                        tempPics = obj.res
                        showModal('Get File List Success\n' + JSON.stringify(tempPics),
                            'ok', null)
                    } else {
                        showModal('Get File List Fail\n' + JSON.stringify(obj), 'ok',
                            null)
                    }
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * 지정한 파일의 내용을 취득
         * `txt, jpg, jpeg, png, gif`파일 지원
         * Image 파일의 경우: [data:image/jpeg;base64, data] 형태의 인코딩 데이터
         * @return: '{src:base64인코딩된 파일 내용, name:파일명 size:파일크기 type:파일타입}'
         */
        function execFileContents() {
            toastFunc(arguments.callee.name)
            /*
              절대 경로: {'path':'C:\xxx\xxx.txt'}
              상대경로: {'path': '${ResourceRoot}\res\xxx.txt'}
              Android 외부 저장소: {'path':'${ExternalRoot}\res'}
            */
            try {
                var parameter
                console.log(typeof tempPics)
                if(tempPics === '' || tempPics.length === 0) {
                    showModal('File이 없습니다.\n가져올까요?', 'confirm', execFileList)
                } else {
                    parameter = {'path': tempPics[0].fullpath}
                }

                miapsWp.callNative('filecontents', parameter, '', function (data) {
                    var obj = miaps.parse(data)

                    if (obj.code === 200) {
                        showModal('<img src="'
                            + JSON.stringify(obj.res.src).replace(/"/g, '')
                            + '" alt="fileImg" width="100%">', 'ok', null)
                    } else {
                        showModal('Fail\n' + JSON.stringify(obj), 'ok', null)
                    }
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * 지정한 파일을 임시 저장 디렉토리에 업로드
         * 임시 저장된 파일을 다른 곳으로 옮기려면 커넥터에서 구현 필요
         * @return: 업로드된 경로
         * [{'name':파일명, 'filename':임시 업로드된 경로}]
         */
        function execFileUpload() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {}
                var fileList = []
                if (tempPics.length > 0) {
                    for (var i = 0; i < tempPics.length; i++) {
                        fileList.push({'path': tempPics[i].fullpath})
                    }
                    parameter = {
                        'files': fileList,
                        'pathname': '/minkSvc'
                    }
                } else {
                    showModal('File이 없습니다.', 'ok', null)
                    return false
                }

                miapsWp.callNative('fileupload', parameter, '', function (data) {
                    var obj = miaps.parse(data)

                    if (obj.code === 200) {
                        showModal('Upload Success\n' + JSON.stringify(obj.res), 'ok', execFileDelete)
                    } else {
                        showModal('Upload Fail\n' + JSON.stringify(obj))
                    }
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        function execFileDelete() {
            toastFunc(arguments.callee.name)
            try {
                var parameter
                var fileList = []
                if (tempPics.length > 0) {
                    for (var i = 0; i < tempPics.length; i++) {
                        fileList.push(tempPics[i].fullpath)
                    }
                }
                parameter = '${ResourceRoot}/temp'

                miapsWp.callNative('filedelete', parameter, '', function (data) {
                    var obj = miaps.parse(data)

                    if (obj.code === 200) {
                        showModal('Delete Success\n' + JSON.stringify(obj.res), 'ok',
                            null)
                    } else {
                        showModal('Delete Fail\n' + JSON.stringify(obj), 'ok', null)
                    }
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * param으로 전달할 패키지명에 해당하는 앱이 설치되었는지 확인
         * @return: boolean
         */
        function execIsInstalled() {
            toastFunc(arguments.callee.name)
            try {
                /*
                Android는 패키지명, iOS는 Scheme 입력
                Scheme은 이름만 넣음(miaps://일 경우, miaps만 입력)
               */
                var parameter = {}

                miapsWp.callNative('isinstalled', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * String 암호화
         * @return: 암호화된값
         */
        function execEncrypt() {
            toastFunc(arguments.callee.name)
            try {
                // 128 or 256
                var parameter = {type: 'AES128', data: 'URL인코딩된 String데이터'}

                miapsWp.callNative('encrypt', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * String 복호화
         * @return: 복호화된값
         */
        function execDecrypt() {
            toastFunc(arguments.callee.name)
            try {
                // 128 or 256
                var parameter = {
                    type: 'AES128',
                    data: 'jRHT6HjjrF6c62pSGDQZSqbDew3HYiBwVi12Jnne6JU='
                }
                miapsWp.callNative('decrypt', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * 장치의 기본 연락처 앱에 정보 저장
         * @return: 성공여부
         */
        function execSaveContact() {
            toastFunc(arguments.callee.name)
            showModal('사용자의 연락처에 샘플 정보가 등록됩니다.\n'
                + '계속 진행하시겠습니까?', 'confirm', function () {
                try {
                    toastFunc('연락처에 접근합니다.')
                    var parameter = {
                        'name': '성명',
                        'mobile': '폰번호',
                        'email': '이메일',
                        'cpn_tel': '회사전화번호',
                        'cpn_name': '회사명',
                        'cpn_addr': '회사주소',
                        'cpn_zip': '우편번호',
                        'cpn_fax': '팩스번호',
                        'department': '부서명',
                        'position': '직책',
                        'base64_img': 'base64이미지데이터'
                    }

                    miapsWp.callNative('savecontact', parameter, '', function (data) {
                        showValue(data)
                    })
                } catch (e) {
                    showModal(e, 'ok', null)
                }
            })

        }

        /**
         * 장치의 기본 연락처의 간단한 정보를 가져옴
         * @return:
         */
        function execLoadContact() {
            toastFunc(arguments.callee.name)
            try {
                miapsWp.callNative('loadcontact', 'simplelist', '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * 현재 화면 캡쳐하여 앱 내부 저장소에 저장
         * @return: Success(200), Fail(400)
         */
        function execCapture() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {}

                miapsWp.callNative('capture', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * 단말을 흔들면 miaps_notify.js의 callback 함수 호출
         * 1회 콜백 호출 후 초기화
         * 이벤트를 다시 받으려면 다시 실행 필요
         * @return:
         */
        function execShake() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {}

                miapsWp.callNative('shake', parameter, '', function (data) {
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * 상단바 색상 변경
         * @return:
         */
        function execStatusBarColor() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {statusbar: '100,50,100'}

                miapsWp.callNative('color', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * 장치에 연결된 IP
         * @return: IP Address
         */
        function execDeviceIP() {
            toastFunc(arguments.callee.name)
            try {
                miapsWp.callNative('deviceip', 'IPv4', '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * 장치가 연결된 방식
         * @return: wifi, mobile, none
         */
        function execNetwork() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {}

                miapsWp.callNative('network', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /**
         * App 정보 가져오기
         * @return:
         * {'common' :
         * {'serverurl' : 'http://192.168.0.10:8080',
         * 'packagenm' : 'kr.co.miaps.hybrid.testsample',
         * 'timeout' : 500,
         * 'toolbar' : false,
         * 'usepush' : true,
         * 'starturl' : 'samples2/index.html',
         * 'runmode' : 'dev'
         * }}
         */
        function execApplicationInfo() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {}

                miapsWp.callNative('applicationinfo', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        function execEnableBackButton() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {}

                miapsWp.callNative('enablebackbtn', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        function execDisableBackButton() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {}

                miapsWp.callNative('disablebackbtn', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        function execClearHistory() {
            toastFunc(arguments.callee.name)
            try {
                var parameter = {}

                miapsWp.callNative('clearhistory', parameter, '', function (data) {
                    showValue(data)
                })
            } catch (e) {
                showModal(e, 'ok', null)
            }
        }

        /*
            Set Button Event
         */
        $('#btn-watermark').on('click', execWatermark)
        $('#btn-scan').on('click', execScan)
        $('#btn-session').on('click', execSession)
        $('#btn-geolocation').on('click', execGeolocation)
        $('#btn-finger-start').on('click', execFingerStart)
        $('#btn-finger-checkdevice').on('click', execFingerCheckDevice)
        $('#btn-finger-checkreg').on('click', execFingerCheckReg)
        $('#btn-appid').on('click', execAppID)
        $('#btn-bundleid').on('click', execBundleID)
        $('#btn-version').on('click', execVersion)
        $('#btn-language').on('click', execLanguage)
        $('#btn-device-id').on('click', execDeviceID)
        $('#btn-device-model').on('click', execDeviceModel)
        $('#btn-value-save').on('click', execValueSave)
        $('#btn-value-load').on('click', execValueLoad)
        $('#btn-value-clear').on('click', execValueClear)
        $('#btn-platform').on('click', execPlatform)
        $('#btn-platform-version').on('click', execPlatformVersion)
        $('#btn-timezone').on('click', execTimezone)
        $('#btn-istablet').on('click', execIsTablet)
        $('#btn-newbrowser').on('click', execNewbrowser)
        $('#btn-camera').on('click', execCamera)
        $('#btn-gallery').on('click', execGallery)
        $('#btn-file-list').on('click', execFileList)
        $('#btn-file-contents').on('click', execFileContents)
        $('#btn-file-upload').on('click', execFileUpload)
        $('#btn-file-delete').on('click', execFileDelete)
        $('#btn-isinstalled').on('click', execIsInstalled)
        $('#btn-encrypt').on('click', execEncrypt)
        $('#btn-decrypt').on('click', execDecrypt)
        $('#btn-savecontact').on('click', execSaveContact)
        $('#btn-loadcontact').on('click', execLoadContact)
        $('#btn-capture').on('click', execCapture)
        $('#btn-shake').on('click', execShake)
        $('#btn-statusbar-color').on('click', execStatusBarColor)
        $('#btn-deviceip').on('click', execDeviceIP)
        $('#btn-network').on('click', execNetwork)
        $('#btn-applicationinfo').on('click', execApplicationInfo)
        $('#btn-enablebackbtn').on('click', execEnableBackButton)
        $('#btn-disablebackbtn').on('click', execDisableBackButton)
        $('#btn-clearhistory').on('click', execClearHistory)

        // $('#btn').on('click', event)
        $('#btn-back').on('click', function () {
            window.history.back()
        })

        /* common function */
        /**
         * show Toast Msg
         * @param fn
         */
        function toastFunc(fn) {
            if(fn.startsWith('exec')) {
                fn.replace('exec', '')
                fn = fn + ' clicked'
            }
            new Android_Toast({
                'duration': 1000,
                'content': fn
            })
        }

        /**
         * show Return Value as Modal
         * @param data: callback return data
         */
        function showValue(data) {
            var obj = miaps.parse(data)

            if (obj.code === 200) {
                showModal('Success\n' + JSON.stringify(obj.res), 'ok', null)
            } else {
                showModal('Fail\n' + JSON.stringify(obj), 'ok', null)
            }
        }
    })