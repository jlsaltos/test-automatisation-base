import com.intuit.karate.junit5.Karate;

class KarateBasicTest {
    static {
        System.setProperty("karate.ssl", "true");
    }

    //test
    @Karate.Test
    Karate testBasic() {
        return Karate.run("classpath:karate-test.feature");
    }

}
