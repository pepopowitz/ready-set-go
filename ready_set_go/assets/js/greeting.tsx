import React from 'react';
interface GreetingProps {
  name: string;
}
const Greeting: React.FC<GreetingProps> = ({ name }) => {
  return (
    <p mt-2 text-md leading-5>
      Greetings {name}, from TypeScript and React!
    </p>
  );
};
export default Greeting;
