module Spec where
import PdePreludat
import Library
import Test.Hspec

correrTests :: IO ()
correrTests = hspec $ do
  describe "Test palabrasRiman" $ do
    it "Las palabras parcial y estirar deben rimar (es una rima asonante)" $ do
      palabrasRiman "parcial" "estirar" `shouldBe` True
    it "Las palabras funcion y cancion deben rimar (es una rima consonante)" $ do
      palabrasRiman "funcion" "cancion" `shouldBe` True
    it "Las palabras parcial y pato no deben rimar (no es una rima asonante ni tampoco rima consonante)" $ do
      palabrasRiman "parcial" "pato" `shouldBe` False

