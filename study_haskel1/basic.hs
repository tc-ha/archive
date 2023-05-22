main = putStrLn "start"

-- 함수를 정의하는 것이 언어의 기본 동작 -> 함수 예약어 없음
mysum x y = x + y

-- 함수의 타입 명세
---- 엄격한 타입 시스템을 갖고 있지만 힌들리-밀너 타입 추론 시스템을 갖고 있어 타입을 일일이 기재하지 않아도 됨
---- 함수명 :: 입력 타입 -> 출력 타입
sum1 :: Int -> Int
sum1 x = x + 1

---- 2개의 Int 입력 인자를 받아 한 개의 Int 타입 출력
---- 함수의 타입 명세에서 반환 타입은 언제나 마지막 1개 (그 전 타입은 모두 입력 인자의 타입)
mysum2 :: Int -> Int -> Int
mysum2 x y = x + y

-- (+) :: Num a => a -> a -> a
---- 의미: a가 Num이라는 타입 클래스에 속하는 타입
---- Num 타입 클래스에 속하는 타입들: Int, Float, Double 등
---- a의 의미: 타입 변수; 아무런 제약이 없으면 어떤 타입이든 될 수 있음

-- 패턴 매칭
---- 함수, 타입, 패턴 매칭은 하스켈 이해의 빌딩 블록
simplefunc2 :: Int -> Int
simplefunc2 3 = 5
simplefunc2 x = x + 1

---- 3에 대해서는 5를 반환하고 그 외에는 +1
---- 입력 값 별로 서로 다른 값을 반환하는 구조는 특히 재귀 함수 정의 시 유용
factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)

fibonaci :: Int -> Int
fibonaci 0 = 0
fibonaci 1 = 1
fibonaci n = fibonaci (n - 1) + fibonaci (n - 2)

-- 가드를 사용한 조건 분기
---- 패턴 매칭을 더 정교한 조건으로 수행할 수 있음
grade :: Int -> String
grade point
  | point > 90 = "A"
  | point > 80 = "B"
  | point > 70 = "C"
  | otherwise = "D"

-- 람다 함수
---- (\인자1 인자2 -> 식)
------ (\x -> x + 2) 3
------ 5
---- 1급 시민으로 다뤄짐. 따라서 변수에 대입 가능
-- let mylambda = (\x -> x + 2)
-- mylambda 3

---- 람다 함수를 입력 인자로 받아들이는 함수
------ (Int -> Int)는 함수를 의미
functionAsInput :: (Int -> Int) -> Int -> Int
functionAsInput fp x = fp x

---- 그럼 이제 이렇게 실행 가능; functionAsInput (\x -> x + 1) 3

---- 람다 함수를 반환하는 함수
functionAsOutput :: Int -> (Int -> Int)
functionAsOutput x = (\y -> y + x)

---- 그럼 이제 이렇게 실행 가능; functionAsOutput 3 5

-- 리스트
---- 기본 조작
---- []: 리스트를 나타내는 기호; [1, 2, 3]
---- 하나의 리스트에는 하나의 타입만 가능
---- 리스트 앞에 요소 하나 삽입하는 방법은 ':'
---- 예시) 1 : [2, 3] => [1, 2, 3]

---- 두 리스트 합치기: ++
---- [1, 2] ++ [3, 4]

---- head: 리스트 첫 요소 반환
---- tail: 첫 요소 제외한 리스트 반환
---- head [1, 2, 3] => 1
---- tail [1, 2, 3] => [2, 3]

---- 리스트 합을 재귀적으로 구하기
sumOfList :: [Int] -> Int
sumOfList [] = 0
sumOfList [a] = a
sumOfList (head : tail) = head + sumOfList tail

---- [Int]: Int 타입 리스트
---- []: 빈 리스트
---- [a]: 리스트에 값 하나만
---- (head:tail): 리스트에 값이 2개 이상 있는 경우

---- 연습문제1
---- 리스트의 최댓값을 구하는 재귀 함수 maxOfList
maxOfList :: [Int] -> Int
maxOfList [a] = a
maxOfList (head : tail)
  | head > maxOfList tail = head
  | otherwise = maxOfList tail

---- 연습문제2
---- 리스트의 n번째 값을 반환하는 재귀 함수 nth
nth :: [Int] -> Int -> Int
nth [] x = -1
nth (head : tail) 1 = head
nth (head : tail) x = nth tail (x - 1)

-- nth (x : xs) n
--     | n == 1 = x
--     | otherwise = nth xs (n - 1)
-- nth [] _ = error "Empty list or n is out of range"

-- 고차 함수
---- map, filter, foldl

---- map (\x -> x + 1) [1, 2, 3]
---- filter (\x -> even x) [1, 2, 3]
---- foldl (\x y -> x + y) 0 [1, 2, 3]

---- 각 고차함수는 람다 함수와 리스트를 입력으로 받음
---- foldl 함수는 초깃값과 리스트의 첫 번째 값이 람다 함수에 적용된 결과가 리스트의 다음 값과 함께 람다 함수에 적용
---- (((0 + 1) + 2) + 3)

---- map을 재귀 함수로 직접 정의해보자
-- mymap :: (Int -> Int) -> [Int] -> [Int]
mymap :: (a -> b) -> [a] -> [b]
mymap fp [] = []
mymap fp [a] = [fp a]
mymap fp (x : xs) = [fp x] ++ (mymap fp xs)

-- 책에서 한 방법은 mymap fp (head : tail) = fp head : mymap fp tail

-- 고차 함수 filter를 재귀 함수로 구현
myfilter :: (Int -> Bool) -> [Int] -> [Int]
myfilter fp [] = []
myfilter fp [a]
  | fp a = [a]
  | otherwise = []
myfilter fp (x : xs)
  | fp x = [x] ++ myfilter fp xs
  | otherwise = [] ++ myfilter fp xs

---- 다른 사람이 짠 코드
filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' f (x : xs)
  | f x = x : filter' f xs
  | otherwise = filter' f xs

-- 고차 함수 foldl를 재귀 함수로 구현
myfoldl :: (a -> a -> a) -> a -> [a] -> a
myfoldl fp a [] = a
myfoldl fp a (x : xs) = myfoldl fp (fp a x) xs

---- 다른 사람이 짠 코드
foldl' :: (b -> a -> b) -> b -> [a] -> b
foldl' _ acc [] = acc
foldl' f acc (x : xs) = foldl' f (f acc x) xs
