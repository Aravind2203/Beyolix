import Logo from "./assets/logo.png";
import {Text , Box  ,Code , Stack , Image ,   useColorModeValue  , Spacer , Button , Flex, Container} from "@chakra-ui/react";
 
const Footer = () => {

    const style = {
        fontFamily: "system-ui",
        position: 'fixed',
        bottom: '0',
        left: '0',
        zIndex: '9',
        width: '100%',
    }

  const textColor = useColorModeValue('gray.600' , 'gray.600')

    return (
        <Box style={style} bg="gray.100" px="10" py="5">
            <Container maxW='container.xl'>
            <Flex alignItems="center" >
           <Stack direction="row" isInline>
          <Image
            boxSize="35px"
            objectFit="contain"
            src={Logo}
            alt="Beyolix"
          />
          <Text size="lg" color={textColor} >Beyolix &nbsp;
          <Spacer />
          <span>
            <Code colorScheme={textColor} color="gray">v1.0.0</Code>
          </span> 
          </Text>
          
        </Stack> 
        <Spacer />
        <Text fontSize='sm' color={textColor} >
       Proudly built with ❤️ in India 
        </Text>
        <Spacer />
        <Text fontSize='sm' color={textColor}>
       Released under MIT License | Copyright @ 2022
        </Text>
        </Flex>
        </Container>
        </Box>
    );
}
export default Footer;
 