# 🎮 Dart Console RPG Game

Dart로 만든 간단한 콘솔 기반 전투 RPG 게임입니다.  
캐릭터를 생성하고, 랜덤으로 등장하는 몬스터와 전투를 벌이며 승리 또는 패배를 경험할 수 있습니다.



---

## 🚀 실행 방법

### 1. 프로젝트 클론

```bash
git clone https://github.com/your-username/rpg_game.git
cd rpg_game
2. 캐릭터 / 몬스터 스탯 파일 작성
characters.txt

복사
편집
50,10,5
(체력, 공격력, 방어력)

monsters.txt

복사
편집
Spiderman,20,5
Batman,30,12
Superman,25,8
(이름, 체력, 최대공격력)

3. 게임 실행
bash
복사
편집
dart run
🎮 게임 규칙
게임 시작 시 캐릭터 이름을 입력합니다.

입력한 이름과 characters.txt의 정보를 바탕으로 캐릭터가 생성됩니다.

몬스터는 monsters.txt에서 랜덤하게 등장하며, 전투는 턴제로 진행됩니다.

각 턴마다 캐릭터는 공격(1) 또는 방어(2) 중 선택할 수 있습니다.

방어 시 방어력이 일시적으로 증가하며, 턴 종료 후 원상 복구됩니다.

몬스터는 랜덤한 데미지를 가하며, 데미지는 항상 캐릭터 방어력 이상입니다.

모든 몬스터를 처치하면 승리, 캐릭터가 쓰러지면 패배입니다.

게임 종료 후 결과는 result.txt에 저장할 수 있습니다.

✍️ 주요 기능
✅ 파일 입출력 (캐릭터, 몬스터 정보 로딩)

✅ 사용자 입력 검증 (이름 형식 제한)

✅ 몬스터 공격력 랜덤 + 최소 방어력 보장

✅ 콘솔 전투 로그 출력

✅ 게임 결과 파일 저장 여부 선택

✅ 추상 클래스 기반 객체지향 구조

📌 예시 실행 화면
less
복사
편집
캐릭터 이름을 입력하세요: 홍길동
홍길동 - 체력: 50, 공격력: 10, 방어력: 5

[Spiderman]이 등장했습니다. (HP: 20, MaxAtk: 5)

[1] 공격하기  [2] 방어하기
행동 선택: 1
[홍길동]의 공격! → [Spiderman]에게 10 데미지를 입혔습니다.
...

결과를 저장하시겠습니까? (y/n): y
결과가 result.txt에 저장되었습니다.
🛠 개발 환경
Dart SDK 3.x

VSCode or CLI 사용

운영체제 무관 (Mac/Windows/Linux)

📄 License
MIT License

yaml
복사
편집

---

원하는 스타일(한글/영문, 이모지 있음/없음)에 맞게 조정도 가능해.  
필요하면 `.gitignore`, `result.txt` 자동 제외 등도 도와줄게!  
이 README, 바로 `rpg_game/README.md`에 붙이면 돼.  
업로드 후 커밋 메시지는 예를 들어:

```bash
git add README.md
git commit -m "📄 Add project README"
git push
